Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbaFSNaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 09:30:06 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:45180 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaFSNaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:30:04 -0400
Date: Thu, 19 Jun 2014 14:29:59 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, kernel@stlinux.com,
        devicetree@vger.kernel.org, srinivas.kandagatla@gmail.com,
        thierry.reding@gmail.com
Subject: Re: [STLinux Kernel] [PATCH 4/7] ARM: stih416-b2020e: Enable PWM on
 the B2020 Rev-E
Message-ID: <20140619132959.GA22592@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1403103172-19856-1-git-send-email-lee.jones@linaro.org>
 <1403103172-19856-4-git-send-email-lee.jones@linaro.org>
 <20140619090546.GB2131@griffinp-ThinkPad-X1-Carbon-2nd>
 <20140619092042.GB26560@lee--X1>
 <20140619101236.GA7390@griffinp-ThinkPad-X1-Carbon-2nd>
 <20140619112239.GC26560@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619112239.GC26560@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

> > > Purely for testing purposes, as it's the only board I have.  If
> > > anyone has the other revisions and would be happy to test the driver
> > > for me then great.
> > 
> > Ok that's what I suspected.
> > 
> > If you tell me how, I can test on a Rev C board. But as there are several other 
> > revisions I think checking the board schematics would be the quickest way forward.
> 
> Great.  Do you have a oscilloscope/logic analyser?

I have an old scope, and I've been wanting to buy a decent logic analyser ;-)
Also can you email me the rev E schematic? I currently only have rev C.

> > > > If you make the stih415 DT PWM nodes part of this series as well, then 
> > > > assuming there is no good reason to the contary, the PWM could 
> > > > be enabled for both stih415/6 in the common stih41x-b2020 DTS file which
> > > > is also included by rev-E (assuming that PWM wiring is not some rev-E specific
> > > > thing).
> > 
> > Can you add the stih415 bindings in V2 as well?
> 
> Who's using Orly1?

I'll let ST answer that.

AFAIK drivers upstreamed so far for Orly based hardware have generally been enabled for both
SoCs, hence querying why the stih415 bindings are missing from this series.

Being pinout compatible, a b2020 board can be populated with a stih415, so it seems strange 
for it to then be missing PWM support given that the SoC, board and pwm driver all support it.

regards,

Peter.
