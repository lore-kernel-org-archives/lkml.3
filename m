Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbaELSFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 14:05:00 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:59868 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbaELSE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 14:04:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Tivy <rtivy@ti.com>
Subject: Re: [PATCH] remoteproc: da8xx: don't select CMA on no-MMU
Date: Mon, 12 May 2014 20:04:30 +0200
Message-ID: <4687391.ryfZfnW8rY@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAK=WgbZ1c6=_MT0tb0X_E58ia=bSSGc5o_kHV_g0jJuDCtB5oA@mail.gmail.com>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de> <1399560990-1402858-18-git-send-email-arnd@arndb.de> <CAK=WgbZ1c6=_MT0tb0X_E58ia=bSSGc5o_kHV_g0jJuDCtB5oA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ej88eztgls0OPKkG1pOw0sKubLaPyi/F+zyoijUg2eP
 a72+UKukLunGPqIj0Z/xZaQV3yhfXkzfvb6HVs4L5Oo2XM3kHV
 6t8PO1wXXy3ZN2KXAFAZFUF4Hs0XmEWRB7SW9pOMjjL3P9kkPh
 xYR6psrkguanfgyBR7OXFALYZX8y02bmO4BkIdqyC0FWBADiXZ
 DXJeCeBAy+U4mst0pQFFBCwBxTMgBi2z+b500ocprYaKpkccTI
 QrxeVJp5reS7S7e4aAGtLHFFabLF2WjQV0kNrnmMxSI2iCxZo7
 YXlJxzELqrbk7OAS6B5Qj6SqWjHISgp/7f8Yn50Aarn0zot0TU
 LIp4ZY/QveADuCMikZ+A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 May 2014 16:09:56 Ohad Ben-Cohen wrote:
> 
> On Thu, May 8, 2014 at 5:56 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > We can only use CMA on systems that have an MMU, because of
> > the requirement to use memory migration. NOMMU systems are
> > rather constrained to start with, but it seems reasonable
> > to assume that DMA allocations can still succeed in the
> > constrained case for remoteproc on NOMMU, so this patch
> > changes the da8xx implementation to not rely on CMA when
> > the MMU is disabled.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Ohad Ben-Cohen <ohad@wizery.com>
> > Cc: Robert Tivy <rtivy@ti.com>
> > ---
> 
> Would you like me to pick this via the remoteproc tree or are you
> planning to route this set elsewhere anyway?

I'd prefer if you could pick it up into your tree.

	Arnd
