Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbaFBBwu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 21:52:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55251 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaFBBwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 21:52:49 -0400
Date: Sun, 01 Jun 2014 18:52:45 -0700 (PDT)
Message-Id: <20140601.185245.1776835653575236303.davem@davemloft.net>
To: rickard_strandqvist@spectrumdigital.se
Cc: tkhai@yandex.ru, paul.gortmaker@windriver.com, peterz@infradead.org,
        bhelgaas@google.com, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: sparc: kernel: smp_64.c: Optimization of the Code
From: David Miller <davem@davemloft.net>
In-Reply-To: <1401659298-18067-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1401659298-18067-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 01 Jun 2014 18:52:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sun,  1 Jun 2014 23:48:18 +0200

> From what I know, AND is faster then modulo.
> Not sure if this is worth changing though.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

This code came from the IA-64 arch code, so you probably want to
fix either both or neither.

I'd say neither, this is not a performance critical path and the
intent is clearer when expressed as a modulus.
