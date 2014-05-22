Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaEVWSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 18:18:15 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39023 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaEVWSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 18:18:14 -0400
Message-ID: <537E77A4.908@codeaurora.org>
Date: Thu, 22 May 2014 15:18:12 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Christopher Covington <cov@codeaurora.org>
CC: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [RFC] ARM: tty: Move HVC DCC assembly to arch/arm
References: <1382120064-2459-1-git-send-email-cov@codeaurora.org> <52617F22.6030900@codeaurora.org> <537E74C1.7020509@codeaurora.org>
In-Reply-To: <537E74C1.7020509@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/14 15:05, Christopher Covington wrote:
> Hi Stephen,
>
> On 10/18/2013 02:34 PM, Stephen Boyd wrote:
>> On 10/18/13 11:14, Christopher Covington wrote:
>>> Put architecture-specific assembly code where it belongs,
>>> allowing for support of additional architectures such as arm64 in
>>> the future.
>> Do you have that patch too? There was also a patch a year ago to add
>> armv5/v4 support to this driver. Maybe we can resurrect that too.
> I still haven't gotten around to testing that one.

It would be nice if that patch was sent along with this one, or if you
have some armv8 patch that works too. This patch by itself doesn't seem
too useful because we're just moving code around in preparation for
supporting this driver on multiple arches.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

