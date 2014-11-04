Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaKDQhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:37:18 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:54138 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaKDQhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:37:15 -0500
Message-ID: <545900B8.3030705@codeaurora.org>
Date: Tue, 04 Nov 2014 10:37:12 -0600
From: Timur Tabi <timur@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Ning Li <ning.li@intel.com>, Alan Cox <alan@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] pinctrl: Intel Cherryview/Braswell support
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com>	<20141104082056.GG1618@lahna.fi.intel.com>	<20141104093907.GH1618@lahna.fi.intel.com>	<4832015.R1NooRni06@vostro.rjw.lan> <CACRpkdaZYubzEKVKiG4vCnh2kDr7CfRvaXcJNHSFtSUaRdXW4A@mail.gmail.com>
In-Reply-To: <CACRpkdaZYubzEKVKiG4vCnh2kDr7CfRvaXcJNHSFtSUaRdXW4A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2014 07:48 AM, Linus Walleij wrote:
> I've landed these two patches for v3.19, I guess we can wait for the
> device properties to land properly upstream before proceeding
> with ACPI support ...? Or are you guys working with one finger
> constantly on the fast-forward button? :D

I'll consider any ACPI enhancements as soon as they're more-or-less 
stable, although I prefer to wait until they're in linux-next.

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum, a Linux Foundation Collaborative Project.
