Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab3I2SBW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 14:01:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60919 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754345Ab3I2SBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 14:01:19 -0400
Date: Sun, 29 Sep 2013 20:01:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Linux-Kernel mailing list <linux-kernel@vger.kernel.org>,
        Linux Torvalds <torvalds@osdl.org>, Alan Cox <alan@redhat.com>
Subject: Re: [PATCH 1/1] x86_64: add config options to optimize for newer AMD
 processors
Message-ID: <20130929180101.GB5490@pd.tnic>
References: <52486938.4090009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52486938.4090009@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 01:54:00PM -0400, Austin S Hemmelgarn wrote:
> From: Austin S. Hemmelgarn <ahferroin7@gmail.com>
> 
> This patch adds Kconfig options to allow optimization for AMD family
> 10h, AMD Bulldozer, and AMD Piledriver derived CPU's in version
> 3.12-rc2.  These provide noticeable improvements over the K8 config
> option, and allow the kernel to take full advantage of AMD specific
> instruction set extensions, such as ABM, LZCNT, and POPCNT.

A patch like that keeps popping up every couple of months. Please show
us those noticeable improvements because the guy last time failed to do
so.

And also, keep in mind that distro kernels are built with
CONFIG_GENERIC_CPU so CPU-specific kernels are used only by the small
percentage of people who actually do build their own kernels.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
