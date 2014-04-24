Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbaDXNXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:23:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55800 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbaDXNXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:23:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [RFC PATCH 0/4] vmlinux.lds.h clean-ups
Date: Thu, 24 Apr 2014 15:23:01 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Rob Herring <robh@kernel.org>
References: <1395949317-8738-1-git-send-email-robherring2@gmail.com> <CAL_JsqKn_erNnGwdXwg6C08pHHQuQn-4fpmp70agvH5ok=P9-g@mail.gmail.com>
In-Reply-To: <CAL_JsqKn_erNnGwdXwg6C08pHHQuQn-4fpmp70agvH5ok=P9-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201404241523.01452.arnd@arndb.de>
X-Provags-ID: V02:K0:cbi14mtHCnQ+/gfV+0ygS5+FTrbVKBmYmD2/fprQ4WI
 bWXsKtntX2J/P8mtDSSxoUUMqPdAwZW3vljomUvtuJP/Wi3MSz
 uwuaXLAVf7uMEk+NeItr/EuVeNl66z6TMSromrm9KfOJtmwaXZ
 Ye/vQAMct5VMkYacJzUSHieH+h3WfKC+QBfLVY3Vgd7urDSq73
 s/+dkx/UOKzfpG4fuD/sX2JTYV1QXP3BEV91au2gJ41oZ8q5wi
 rTwsYvlvkXBQzpgL32r1g32MXhddlo1tkYo1ixekdeffdND4jY
 h6AvVH2IEC+XG/Nw4wYmGRckSwkI8riDDHVEMb+HEEXxL2ziZn
 jQAIw8ITIjZhKm5ZPX+U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 April 2014, Rob Herring wrote:
> >
> >  arch/arm/kernel/devtree.c         |  11 +--
> >  drivers/irqchip/irqchip.c         |   6 +-
> >  include/asm-generic/vmlinux.lds.h | 142 +++++++++++---------------------------
> 
> Arnd, Any comments on this series?
> 

No qualified comments. The linker script is always magic to me. For all I can
tell, it's all good and you can add an Acked-by from me if that helps you,
but I'm not able to judge whether it's correct. Do you want to merge it
through the DT git?

	Arnd
