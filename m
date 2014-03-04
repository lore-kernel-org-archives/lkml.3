Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbaCDKjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:39:51 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46620 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709AbaCDKjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:39:49 -0500
Message-ID: <5315AD6F.1070804@gmail.com>
Date: Tue, 04 Mar 2014 11:39:43 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2] ARM: dove: dt: revert PMU interrupt controller node
References: <20140207180836.GE8533@titan.lakedaemon.net> <1392667236-19126-1-git-send-email-jason@lakedaemon.net> <20140303150215.GI21483@n2100.arm.linux.org.uk> <20140303173740.GC16655@lunn.ch> <20140303181529.GM21483@n2100.arm.linux.org.uk> <20140303222406.GW1872@titan.lakedaemon.net> <20140304092616.GH16655@lunn.ch>
In-Reply-To: <20140304092616.GH16655@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 10:26 AM, Andrew Lunn wrote:
>> I could have sworn this was discussed with this particular patchset, but
>> I'm unable to find the conversation in my archives.  Neither during the
>> patch submission process, nor the (long) pull request thread.
>>
>> Perhaps it was an irc conversation?  Andrew, Sebastian, can you find a
>> link?  iirc, one of the DT maintainers (Mark Rutland?) raised the same
>> concern and I thought we answered that sufficiently...
>
> It was the cpufreq driver which caused the discussion. I looked at it
> for a while, and then task swapped onto the kirkwood move into
> mach-mvebu.

I guess you are looking for this discussion

http://comments.gmane.org/gmane.linux.power-management.general/41053

and specifically Mark's remarks on PMU and DT in here

http://permalink.gmane.org/gmane.linux.ports.arm.kernel/285384

BTW, +1 for a single PMU node that either serves an mfd (or type
of) driver or that subsystem drivers derive their resources from.
Looking at Dove FS, that would also include clock gating, which
could be a mess to sort out.. anyway, let's get it on.

Sebastian
