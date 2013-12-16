Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab3LPK2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:28:14 -0500
Received: from www.linutronix.de ([62.245.132.108]:58978 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab3LPK2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:28:12 -0500
Message-ID: <52AED5BB.1060002@linutronix.de>
Date: Mon, 16 Dec 2013 11:28:11 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Allen Pais <allen.pais@oracle.com>
CC: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH 2/3] sparc64: convert spinlock_t to raw_spinlock_t in
 mmu_context_t
References: <1387166853-10782-1-git-send-email-allen.pais@oracle.com> <1387166853-10782-3-git-send-email-allen.pais@oracle.com>
In-Reply-To: <1387166853-10782-3-git-send-email-allen.pais@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2013 05:07 AM, Allen Pais wrote:
> Issue debugged by Thomas Gleixner <tglx@linutronix.de>

I think davem would appreciate if you add a little here than this. The
same goes for 3/3.

> Signed-off-by: Allen Pais <allen.pais@oracle.com>

Sebastian
