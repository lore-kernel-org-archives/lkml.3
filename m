Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567AbaAaTpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 14:45:39 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53964 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281AbaAaTph convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 14:45:37 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH 2/4] arm: qcom: Split Qualcomm support into legacy and multiplatform
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <3511712.H3ChLoqCm7@wuerfel>
Date: Fri, 31 Jan 2014 13:45:34 -0600
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <AED23932-2BC1-463C-BD1C-D86EBC174B8A@codeaurora.org>
References: <1391107002-21470-1-git-send-email-galak@codeaurora.org> <201401312020.16984.arnd@arndb.de> <2B2190A4-6689-40D8-A3D7-BD2D882A2CF6@codeaurora.org> <3511712.H3ChLoqCm7@wuerfel>
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 31, 2014, at 1:34 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> On Friday 31 January 2014 13:25:25 Kumar Gala wrote:
>>> The hotplug.c change sticks out as something that isn't just a move
>>> of code to another place, but deletion of unused code. It would
>>> be nice to split that out into a separate change, possibly together
>>> with the trivial board.c and smp.c changes.
>> 
>> That’s not 100% true, the hotplug.c code implemented msm_cpu_die, which moved into smp.c
>> 
>> I can split out scm*/smp* into a patch to enable smp if that is really desired, but not exactly sure what it gets us.
>> 
> 
> It's not extremely important, I just prefer splitting patches
> that have any kind of functional change from trivial moves.
> 
> If something happens to break for an unforseen reason, it's
> easier to bisect to the patch that does the change.
> 
> 	Arnd

I’ll push my change to hotplug.c into the SMP patch set that Stephen started.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

