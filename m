Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbaK1Qt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:49:58 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:52490 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbaK1Qt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:49:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Stefan Agner <stefan@agner.ch>, shawn.guo@linaro.org,
        kernel@pengutronix.de, linux@roeck-us.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: imx: src: support vf610 system reset controller
Date: Fri, 28 Nov 2014 17:49:14 +0100
Message-ID: <34359137.rt8QrS7shW@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417193015-6033-3-git-send-email-stefan@agner.ch>
References: <1417193015-6033-1-git-send-email-stefan@agner.ch> <1417193015-6033-3-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:86hN5+AydQBgCZJgsX6CausxPx8RJY/TRhjYA9YZmR6
 u/3RagPgc6FiWLROyZu7icpKE470z6WUSjAFkJqaEvSwYgYVUg
 LbvtQ5li2RgkH7L9bO5bXqTBBZWYhX/2DRfUNqNHTDG/Ki/HCY
 2ADrxP/YbQjU3AwARJgYl4sjoBkBjST0YyhbVrbh1nmd+74Ohk
 PjKtTASs6zp45knlQX33Q3YXA6m0t7vX1nm3FjaGchJyxn+rmL
 kmmTMFbK/Z/YUUjlxML2za7hCuYv+wlc3Nc9mqQ8yUoP7F7nOo
 8JlryfNNVF3zbJgqnihImZiZ5T6U27vSwXcqY5rlh1a60gjB5C
 Yqq6CewlWFoqn/B8Qc4Y=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 November 2014 17:43:35 Stefan Agner wrote:
> Support Vybrid SoC's system reset controller (SRC). Currently we
> don't register a reset controller but only support the imx_cpu_jump
> and imx_cpu_arg functions.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>

I think this should be a platform driver in drivers/power/reset.

If the SRC is also capable of resetting individual blocks instead of just
the entire machine, it would be a reset driver in drivers/reset instead.

	Arnd
