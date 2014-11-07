Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaKGHjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 02:39:22 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:54309 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaKGHjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 02:39:16 -0500
MIME-Version: 1.0
In-Reply-To: <1415011945-3297-1-git-send-email-lftan@altera.com>
References: <1415011945-3297-1-git-send-email-lftan@altera.com>
Date: Fri, 7 Nov 2014 15:39:14 +0800
Message-ID: <CAFiDJ5_6HOPH_g6+Z1GwE87qXaGtnyUZdPvFCbC7E3v0+7o3VA@mail.gmail.com>
Subject: Re: [PATCH v6 00/29] nios2 Linux kernel port
From: "LF.Tan" <lftan.linux@gmail.com>
To: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        sfr@canb.auug.org.au
Cc: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 6:51 PM, Ley Foon Tan <lftan@altera.com> wrote:
>
> This is the 6th version of patchset adds the Linux kernel port for Nios II
> processor from Altera. All of the feedback from v5 patchseries has been
> addressed. Note, only patch #1, #7 and #21 have non-trivial changes.
> Thanks to all who provided feedback on the previous version.
>
> About Nios II Cores
> -------------------
> Nios II is a 32-bit embedded-processor architecture designed specifically for the
> Altera family of FPGAs.
> More information is available  at http://www.altera.com/devices/processor/nios2/ni2-index.html
>
> Instruction set and architecture overview documents can be found on the
> following page:
> http://www.altera.com/literature/lit-nio2.jsp
>
> Nios2 GCC port is in mainline and will be in the FSF 4.9 release.
>
> The patchset are based on v3.18-rc3 and can also be found in the following git tree:
> git://git.rocketboards.org/linux-socfpga-next.git  nios2-upstream
>

Hi Stephen

Review for Nios2 port is completed and ready for upstream. Can you
please add nios2 patchset to linux-next?
Thanks.


The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  http://git.rocketboards.org/linux-socfpga-next.git tags/nios2-for-linux-next

for you to fetch changes up to 1b9e67a57ac633f407de11b36d8f996c368a8c66:

  nios2: Build infrastructure (2014-11-06 15:23:37 +0800)


Regards
Ley Foon
