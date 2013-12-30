Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab3L3Mmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 07:42:52 -0500
Received: from forward16.mail.yandex.net ([95.108.253.141]:42913 "EHLO
	forward16.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab3L3Mmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 07:42:51 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: Allen Pais <allen.pais@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>
In-Reply-To: <1387166853-10782-1-git-send-email-allen.pais@oracle.com>
References: <1387166853-10782-1-git-send-email-allen.pais@oracle.com>
Subject: Re: [PATCH 0/3]  PREEMPT_RT support for Sparc64
MIME-Version: 1.0
Message-Id: <135961388407367@web19g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 30 Dec 2013 16:42:47 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

16.12.2013, 08:08, "Allen Pais" <allen.pais@oracle.com>:
> PREEMPT_RT support for Sparc64.
> I have tested it on UltraSparc T4 (Niagara4).
>
> Allen Pais (3):
> ššsparc64: use generic rwsem spinlocks rt
> ššsparc64: convert spinlock_t to raw_spinlock_t in mmu_context_t
> ššsparc64: convert ctx_alloc_lock raw_spinlock_t
>
> šarch/sparc/Kconfig ššššššššššššššššššššš| ššš7 +++----
> šarch/sparc/include/asm/mmu_64.h šššššššš| ššš2 +-
> šarch/sparc/include/asm/mmu_context_64.h | šš10 +++++-----
> šarch/sparc/kernel/smp_64.c ššššššššššššš| ššš4 ++--
> šarch/sparc/mm/init_64.c šššššššššššššššš| šš14 +++++++-------
> šarch/sparc/mm/tsb.c šššššššššššššššššššš| šš20 ++++++++++----------
> š6 files changed, 28 insertions(+), 29 deletions(-)

Works good on my 16 CPU sun4u.

Tested-by: Kirill Tkhai <tkhai@yandex.ru>
