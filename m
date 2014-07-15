Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbaGOJIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:08:18 -0400
Received: from sym2.noone.org ([178.63.92.236]:54849 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932500AbaGOJIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:08:15 -0400
Date: Tue, 15 Jul 2014 11:08:13 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Ley Foon Tan <lftan@altera.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
Subject: Re: [PATCH v2 00/29] nios2 Linux kernel port
Message-ID: <20140715090813.GE7668@distanz.ch>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405413956-2772-1-git-send-email-lftan@altera.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-15 at 10:45:27 +0200, Ley Foon Tan <lftan@altera.com> wrote:
> This is the 2nd version of patchset adds the Linux kernel port for Nios II processor from
> Altera. All of the feedback from v1 patchseries has been addressed. Thanks to all who
> provided feedback on the previous version.
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
> The patchset are based on v3.16-rc5 and can also be found in the following git tree:
> git://git.rocketboards.org/linux-socfpga-next.git  nios2-upstream

Very nice work Ley Foon! It's great to see the Nios II port finally
making it upstream.

I'll test the series on the NEEK and my custom board some time this
week.

Cheers
Tobias
