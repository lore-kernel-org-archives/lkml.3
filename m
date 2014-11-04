Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbaKDVvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 16:51:12 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:45114 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaKDVvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 16:51:10 -0500
Message-ID: <54594A4B.1030207@codeaurora.org>
Date: Tue, 04 Nov 2014 15:51:07 -0600
From: Timur Tabi <timur@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Ning Li <ning.li@intel.com>, Alan Cox <alan@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] pinctrl: Intel Cherryview/Braswell support
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com> <20141104082056.GG1618@lahna.fi.intel.com> <20141104093907.GH1618@lahna.fi.intel.com> <4832015.R1NooRni06@vostro.rjw.lan>
In-Reply-To: <4832015.R1NooRni06@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2014 07:31 AM, Rafael J. Wysocki wrote:
> Actually, it's better to pull the device-properties branch:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git device-properties
>
> because that contains the lastest changes.  It will be rebased in the future,
> though, so don't merge it into your "immutable" branches.

I wish there were more examples on converting OF calls to device_prop* 
calls.  I can't figure out how to obtain the size of a property without 
reading the property data.  I think device_property_present() should be 
modified to take an optional size property, just like of_find_property().

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
