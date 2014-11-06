Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367AbaKFSBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:01:19 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:43672 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaKFSBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:01:18 -0500
Message-ID: <545BB76B.3070109@codeaurora.org>
Date: Thu, 06 Nov 2014 12:01:15 -0600
From: Timur Tabi <timur@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Ning Li <ning.li@intel.com>, Alan Cox <alan@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] pinctrl: Intel Cherryview/Braswell support
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com> <545912D2.5090708@codeaurora.org> <CACxGe6t=nK83pGNDKmZJ28BZJqgNjGZgckrzVrBiFko1AcT0xg@mail.gmail.com> <1632312.tiWezf5I7W@vostro.rjw.lan> <CACxGe6sVXkiFpXaJccbYP+3ErmvVvZtL=FqkaJQ5FnnsKJ95Fw@mail.gmail.com>
In-Reply-To: <CACxGe6sVXkiFpXaJccbYP+3ErmvVvZtL=FqkaJQ5FnnsKJ95Fw@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 11:37 AM, Grant Likely wrote:
> 2) Where direct control over the pinctrl hardware is required by the
> OS, build it into the GPIO driver functionality (which from what I
> understand is exactly what Mika has done).

So you're saying that if the GPIO driver is asked to read/write data to 
GPIO #35, then the driver should first make sure that the pin #35 is 
configured for GPIO?  What if that pin is configured for I2C instead, 
and now some random driver, is asking to read from GPIO #35, has now 
broken I2C?

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
