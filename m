Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab3AROyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:54:41 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:59973 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266Ab3AROyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:54:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH v2 56/76] ARC: Unaligned access emulation
Date: Fri, 18 Jan 2013 14:54:36 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tim Yao <tim.yao@amlogic.com>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-57-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1358511930-7424-57-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301181454.36279.arnd@arndb.de>
X-Provags-ID: V02:K0:nwQBE8N4tDzblaxQb2jFcyqLVV8pfV6GRj29XVTdebE
 MAi1hyf39xN+rXAw8iVtEPsPG5GZ2CkPWijHt72yAuIc2NlQRf
 I4qb7aiZfpP7zR2TQTksG0ct13wBG0SV9hSpMJivQlPvRNxckL
 uhvrNLuDm2sWc2ueY8QcAEDQqcOqRKZ7LF9gIL1ys56pUvGagB
 raHkEFq+eD2XZr7AY0INZbjsbITsInb0qZaJARSXhS0WdCMkLL
 IRT3NQozRqlY0fIGlDiYjRfqhbvW9WkglowtJq6Qc3g5MQfECp
 CputatM4YdA9TINCP+z413r4AR7++4Zl+kcNK9DDrSxvcGKLvx
 GOusW3h4r2YzmTB0zZhs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013, Vineet Gupta wrote:
> ARC700 doesn't natively support unaligned access, but can be emulated
> -Unaligned Access Exception
> -Disassembly at the Fault address to find the exact insn (long/short)
> 
> Also per Arnd's comment, we runtime control it using 2 sysctl knobs:
> * SYSCTL_ARCH_UNALIGN_ALLOW: Runtime enable/disble
> * SYSCTL_ARCH_UNALIGN_NO_WARN: Warn on each emulation attempt
> 
> Originally contributed by Tim Yao <tim.yao@amlogic.com>
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Cc: Tim Yao <tim.yao@amlogic.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
