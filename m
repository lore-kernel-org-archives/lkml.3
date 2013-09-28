Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab3I1Gkh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 02:40:37 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:38752 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3I1Gkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 02:40:35 -0400
Date: Sat, 28 Sep 2013 08:40:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dave Jones <davej@redhat.com>, x86@kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86: sort reboot DMI quirks by vendor.
Message-ID: <20130928064030.GA16660@gmail.com>
References: <20130927203308.GB22836@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130927203308.GB22836@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Jones <davej@redhat.com> wrote:

> Grouping them by vendor should make it easier to spot duplicates.
> 
> Signed-off-by: Dave Jones <davej@fedoraproject.org>
> 
> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> index e643e74..12521b2 100644
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c

Could you please send this patch against latest -tip? It already has 
changes to the quirks, in the tip:x86/reboot tree (also merged into 
tip:master), which conflict with this change.

Thanks,

	Ingo
