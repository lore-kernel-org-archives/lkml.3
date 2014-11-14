Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161287AbaKNQUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 11:20:21 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:54184 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161247AbaKNQUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 11:20:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Andre Przywara <andre.przywara@arm.com>, will.deacon@arm.com,
        catalin.marinas@arm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] arm64: alternatives runtime patching
Date: Fri, 14 Nov 2014 17:20:10 +0100
Message-ID: <2041011.PXfvHs4Xp7@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415980452-20366-1-git-send-email-andre.przywara@arm.com>
References: <1415980452-20366-1-git-send-email-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:hqFlDF9kxop4/kzhLVg2a2/jB55yrZNO1IcrK3yZFRS
 QZnJzvc6XsMfADfchI7jNzcDaarZB/Xn1ESy+ZkHwLqz5x0GUD
 W6c96Qg9gStRkA2MJmUqLGB+zF9XJrDJN+2nNfgFtjugpVpvB+
 Uc/bRVg72YpZd9mroXA5MHBIxhEqlMe6Sr9bG2dj5AwgR+EHuA
 GNEGLwlYBUXtCIb6j8uAnK76mQjuO/yBqaaiwmUzU17LMN+IzY
 +uLYNMDeaxKAzT6NSbRY9xLtIw7KrLuSbNys0yHsjsSC3JnXja
 lwe7INlQaM7ISd0O9WJnXcz+GiuVM9RskDYHRX6KVxOtOyQfeN
 IDR2ADOVqLINk+GfVrUQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 November 2014 15:54:06 Andre Przywara wrote:
> This series introduces alternatives runtime patching to arm64.
> This allows to patch assembly instruction at runtime to either
> fix hardware bugs or optimize for certain hardware features. Look
> at patch 5/6 for an example on how to use this.
> 

Does it provide a measurable performance benefit? The implementation
seems ok, but we should only add the complexity for things that
actually need it and can't be handled just as well with a run-time
conditional.

	Arnd
