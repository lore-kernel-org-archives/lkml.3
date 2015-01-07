Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbbAGIRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 03:17:14 -0500
Received: from smtp73.ord1c.emailsrvr.com ([108.166.43.73]:50097 "EHLO
	smtp73.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752037AbbAGIRM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 03:17:12 -0500
X-Sender-Id: ken.wilson@opengear.com
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Subject: Re: [PATCH] spi: orion: Add multiple chip select support for Armada 370 and 375
From: Ken Wilson <ken.wilson@opengear.com>
In-Reply-To: <20150107074154.1334b5c0@free-electrons.com>
Date: Wed, 7 Jan 2015 18:08:29 +1000
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux@arm.linux.org.uk, pawel.moll@arm.com,
        broonie@kernel.org, ijc+devicetree@hellion.org.uk,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        robh+dt@kernel.org, ezequiel.garcia@free-electrons.com,
        gerg@uclinux.org, galak@codeaurora.org,
        linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 8BIT
Message-Id: <DA2CCB3A-D11B-4861-8DE1-7316C16E561D@opengear.com>
References: <1420579846-31962-1-git-send-email-ken.wilson@opengear.com> <54AC5B16.9020206@free-electrons.com> <20150107074154.1334b5c0@free-electrons.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
X-Mailer: Apple Mail (2.1990.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,
> On 7 Jan 2015, at 4:41 pm, Thomas Petazzoni <thomas.petazzoni@free-electrons.com> wrote:
> 
> Dear Gregory CLEMENT,
> 
> On Tue, 06 Jan 2015 23:00:54 +0100, Gregory CLEMENT wrote:
> 
>> On 06/01/2015 22:30, Ken Wilson wrote:
>>> Create a new dt binding for the Armada 375 that supports up to
>>> 3 chip selects but uses the same prescaler values and algorithm
>>> as the basic orion binding.
>> 
>> There was already a patch that have been sent for this:
>> http://thread.gmane.org/gmane.linux.kernel.spi.devel/17808/focus=17809
>> 
>> but in the end it has not been merged. The last email on the thread was
>> about doing the manipulation in set_cs and not in setup_transfer(). And I
>> didn't find a newer version.
>> 
>> Maybe it just fell through the cracks.
>> Thomas did you remember of it?
> 
> Yes, it is still on my TODO-list, but I haven't yet gotten around to
> submitting a new version. So I haven't looked at Ken's contribution,
> but if Ken is willing to bring it up to a state where it can be
> mainlined, that would definitely be welcome.

I’m happy to do that

Thanks,
Ken

> 
> Thanks,
> 
> Thomas
> -- 
> Thomas Petazzoni, CTO, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

