Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbaFSLWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 07:22:47 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:63735 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757228AbaFSLWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 07:22:45 -0400
Date: Thu, 19 Jun 2014 12:22:39 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, kernel@stlinux.com,
        devicetree@vger.kernel.org, srinivas.kandagatla@gmail.com,
        thierry.reding@gmail.com
Subject: Re: [STLinux Kernel] [PATCH 4/7] ARM: stih416-b2020e: Enable PWM on
 the B2020 Rev-E
Message-ID: <20140619112239.GC26560@lee--X1>
References: <1403103172-19856-1-git-send-email-lee.jones@linaro.org>
 <1403103172-19856-4-git-send-email-lee.jones@linaro.org>
 <20140619090546.GB2131@griffinp-ThinkPad-X1-Carbon-2nd>
 <20140619092042.GB26560@lee--X1>
 <20140619101236.GA7390@griffinp-ThinkPad-X1-Carbon-2nd>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140619101236.GA7390@griffinp-ThinkPad-X1-Carbon-2nd>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Why are you only enabling this for rev-E board?
> > 
> > Purely for testing purposes, as it's the only board I have.  If
> > anyone has the other revisions and would be happy to test the driver
> > for me then great.
> 
> Ok that's what I suspected.
> 
> If you tell me how, I can test on a Rev C board. But as there are several other 
> revisions I think checking the board schematics would be the quickest way forward.

Great.  Do you have a oscilloscope/logic analyser?

> > > If you make the stih415 DT PWM nodes part of this series as well, then 
> > > assuming there is no good reason to the contary, the PWM could 
> > > be enabled for both stih415/6 in the common stih41x-b2020 DTS file which
> > > is also included by rev-E (assuming that PWM wiring is not some rev-E specific
> > > thing).
> 
> Can you add the stih415 bindings in V2 as well?

Who's using Orly1?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
