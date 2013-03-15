Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab3COKST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 06:18:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49426 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab3COKSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 06:18:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 2/3] mfd: Make AB8500_CORE select POWER_SUPPLY to fix build error
Date: Fri, 15 Mar 2013 10:18:13 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Axel Lin <axel.lin@ingics.com>
References: <1363298204-8014-1-git-send-email-arnd@arndb.de> <1363298204-8014-2-git-send-email-arnd@arndb.de> <20130315064436.GD12559@zurbaran>
In-Reply-To: <20130315064436.GD12559@zurbaran>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303151018.13518.arnd@arndb.de>
X-Provags-ID: V02:K0:nR6AeROKhDT4+nf1D4xptQ6/XADZ1Gtue/ta3N/j3dg
 KRo1r3TGInNHZIAK7eQ8X8AfBlqjqFEWmpFTT2+NDb23Wh1Tq9
 vvG+m1tTB+JX33OnmR2G938JLyg7AVRs9ccYCfop1IliDzzNjf
 cl5wIiGLNPcNxMx5e0k0202UnnqIH5jLKKZaDCtAghRomOFSUG
 JNiqb52gO1VmHpCPFj5Wfyt+LWErIL9iVnTW9Y68IB65c4M/lD
 q13i84pg+rAOVzGVzUZKxzDByNYeTcUtTCfqOz0LnG4W+GGXXA
 nh5H91mVUQ88fgc9TySwpknDINd5q4IaTF3X8RA4AubIW1d94I
 6SP325Rnownc2Y18Ox3Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 March 2013, Samuel Ortiz wrote:
> On Thu, Mar 14, 2013 at 10:56:39PM +0100, Arnd Bergmann wrote:
> > 
> > Please apply to MFD tree for 3.9
> Already applied to mfd-fixes.
> 

For some reason I did not see it when I rebased my patches on top of linux-next
to make sure I don't send any patches again that are already queued up.

Is there a reason why mfd-fixes is not part of linux-next?

	Arnd
