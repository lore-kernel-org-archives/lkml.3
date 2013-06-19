Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab3FSNyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 09:54:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57630 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab3FSNys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 09:54:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Robin Holt <holt@sgi.com>
Cc: akpm@linux-foundation.org, Russell King <rmk+kernel@arm.linux.org.uk>,
        Russ Anderson <rja@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH -v11 resend 10/11] arm, change reboot_mode to use enum reboot_mode
Date: Wed, 19 Jun 2013 15:52:02 +0200
Message-ID: <12642293.RmlRtOVM54@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.4; x86_64; ; )
In-Reply-To: <4169120.1k31YLDD12@wuerfel>
References: <1370519244-49918-1-git-send-email-holt@sgi.com> <1370519244-49918-11-git-send-email-holt@sgi.com> <4169120.1k31YLDD12@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:fT1dbXndlqzyRGPLbQ585VKwT5L6qfjWEvK+RVE2oNO
 cOVsTK//uBDVLEZRYyFoNq/2iPfgsQVkWujJu7BbQ4Tss2nzAs
 3O5POZR4bMhQ2id+n7PoB2ejQ/buZiA5tTWgWhN6Vf7wqgSA4Q
 /VsiiZAoIr5GpQ4ygtRVjVo7+YAyHQtBQNFjvCx4NiuO1XY0bK
 mY9r46q+FyVCHGVQQvYafKqQsnhzSIPA9pAuSiA+aN5FDW50pB
 d9FfQWjmwzRufbiSeU2yk75xh24z4SLiE192IqakgZNjLkA6Hz
 sjTb0qPOcvdj5WWLssRpQbHWSm3j1GfagediJZpEWPFmy1SG89
 At2PehvTlIM8AiGIuS24=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 June 2013 12:58:10 Arnd Bergmann wrote:
> On Thursday 06 June 2013 06:47:23 Robin Holt wrote:
> > Preparing to move the parsing of reboot= to generic kernel code
> > forces the change in reboot_mode handling to use the enum.
> > 
> > Signed-off-by: Robin Holt <holt@sgi.com>
> > To: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> > Cc: Russ Anderson <rja@sgi.com>
> > Cc: Robin Holt <holt@sgi.com>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> > Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> > Cc: the arch/x86 maintainers <x86@kernel.org>
> > Cc: Arm Mailing List <linux-arm-kernel@lists.infradead.org>
> > Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> Should we merge this through the arm-soc tree?
> 
> I'm getting a few conflicts with new platforms getting added
> using the old interface.

Hmm, I realized after sending it that this patch depends on
at least one other patch to add the 'enum'. Any suggestions
for how to handle that?

	Arnd
