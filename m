Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab3ARVGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:06:46 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:64303 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab3ARVGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:06:44 -0500
Date: Fri, 18 Jan 2013 23:06:41 +0200
From: Lasse Collin <lasse.collin@tukaani.org>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] decompressors: make the default XZ_BCJ_* config
 match the selected architecture
Message-ID: <20130118230641.42bbb191@tukaani.org>
In-Reply-To: <50F673F2.4070201@openwrt.org>
References: <1358266931-23401-1-git-send-email-florian@openwrt.org>
	<1358266931-23401-2-git-send-email-florian@openwrt.org>
	<20130115201117.5ce0a690@tukaani.org>
	<50F673F2.4070201@openwrt.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-16 Florian Fainelli wrote:
> On 01/15/2013 07:11 PM, Lasse Collin wrote:
> > On 2013-01-15 Florian Fainelli wrote:
> >>   config XZ_DEC_X86
> >>   	bool "x86 BCJ filter decoder" if EXPERT
> >> -	default y
> >> +	default y if X86
> >>   	select XZ_DEC_BCJ
> > [...]
> >
> > I think the "if EXPERT" strings should be dropped when all BCJ
> > filters aren't enabled by default. One should be able to enable all
> > filters without enabling EXPERT.
> Ok, this would probably be a third patch, since my two patches
> basically just modify what was already there, but I agree with you,
> even though EXPERT is enabled by default on most architectures and
> defconfigs. --

At least in x86_64_defconfig EXPERT isn't enabled. I'm fine with your
patches once also the "if EXPERT" strings are removed.

Acked-by: Lasse Collin <lasse.collin@tukaani.org>

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
