Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbaDAHFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 03:05:19 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:42394 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbaDAHFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 03:05:17 -0400
Date: Tue, 1 Apr 2014 09:05:14 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH v2] avr32: replace simple_strtoul() with kstrtoul()
Message-ID: <20140401070514.GA13853@samfundet.no>
References: <1395177941-5680-1-git-send-email-artagnon@gmail.com>
 <1396312962-12483-1-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396312962-12483-1-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Mon 31 Mar 2014 20:42:42 -0400 or thereabout, Ramkumar Ramachandra wrote:
> simple_strtoul() is marked for obsoletion; use the newer and more
> pleasant kstrtoul() in its place.

Thank you for fixing, I will add it to my for-linus branch and push later
today.

> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/kernel/cpu.c | 48 ++++++++++++++++++++++++++----------------------
>  1 file changed, 26 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/avr32/kernel/cpu.c b/arch/avr32/kernel/cpu.c

<snipp diff>

-- 
mvh
Hans-Christian Egtvedt
