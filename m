Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbaJ2HoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 03:44:19 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:56361 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbaJ2HoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 03:44:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: f.fainelli@gmail.com, tglx@linutronix.de, jason@lakedaemon.net,
        ralf@linux-mips.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mbizon@freebox.fr, jogo@openwrt.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH 04/11] irqchip: Remove ARM dependency for bcm7120-l2 and brcmstb-l2
Date: Wed, 29 Oct 2014 08:44:06 +0100
Message-ID: <2058619.ZZgjsUZogD@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414555138-6500-4-git-send-email-cernekee@gmail.com>
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com> <1414555138-6500-4-git-send-email-cernekee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:kZOOf8G0VdHBkRtfaqPCopcq4yw94IouPP4czLSuCop
 CxnOaBobS6sDsLfRiOHiZTMkTsj4IljGIYcbs2PRi6Rh6kONeQ
 Oz0E0hQQZGS9JP3Z0gXD3FEWTx4Rv1IFsx1VGWZKK8dPPYDSBR
 Cq1x03vWxdFPA9EbSBWeVFL5SzT3k0SnCvq+UOfURfqv7sUpoj
 S0iJvtp4NIZS5sKDrTdSJx5Qv8zjwR3wNxg85oiZVt2Sdpvbfa
 O23FbAWK0SR6QKy7H5BT1Ps5DZ4pkl/gpwwqkE5NGkwJtJ4RZX
 GvLYeDciD4wVRpbTjjLk5EbgYg1QJzAS7i4oX92t1llo2QI3vd
 f+qEvXFRcfxvbjtmJNMg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 20:58:51 Kevin Cernekee wrote:
> This can compile for MIPS (or anything else) now.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> 

It's a silent symbol, so the dependency is obviously not needed,

Acked-by: Arnd Bergmann <arnd@arndb.de>
