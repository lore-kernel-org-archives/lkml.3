Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaBZNrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 08:47:10 -0500
Received: from moutng.kundenserver.de ([212.227.17.24]:64181 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbaBZNrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 08:47:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org, Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH 0/5] ARM: davinci: tnetv107x removal
Date: Wed, 26 Feb 2014 14:46:28 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-spi@vger.kernel.org
References: <1393418614-3968549-1-git-send-email-arnd@arndb.de>
In-Reply-To: <1393418614-3968549-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201402261446.29257.arnd@arndb.de>
X-Provags-ID: V02:K0:DtVqhiyLXtboUhvIM8KtIVhgZXSn9HIaUKeWDzJnnO4
 yrPjLl0u83jQ1L7UgTvH5pEnjHgTQjF9Kbq0NSfa8E2JZSEWYd
 DIyvgxEkAfbtVbFfqKeFtsIaEbKb2uQZNby5kIlKkViSDQ+5cg
 Sa9mc23N9E9UalMwq83oG5iZAxt5BiVm8e4XhWU16F2y4cVfSs
 mmkRxRfXdFdu5kY+rhWgtRwoAXgSPVmdC5TKx4LNAlmyFlGjVz
 RyKfVY08JXB+CkEhp3EI18i+k97vjQC5Kd6ZA7DSVQ0Tl61RkH
 i6L0oIyi/JwuOyC1YWFV8mMzxxSDCfFLncRc+cXGuq3tipQ1vb
 qz0NTdM9ZtiIrDAERpOY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 February 2014, Arnd Bergmann wrote:

> The five patches are completely independent of one another,
> and applying them out of order is fine since we just want
> to remove the code. However, I'm looking for an Ack from
> Cyril Chemparathy and Sekhar Nori first, to be sure we
> won't need this code in the future. Kevin Hilman has
> already mentioned that he sees no reason to keep this
> code.

Hmm, apparently Cyril is no longer at TI. If anyone has his
current email address and thinks he might have an opinion,
could you forward the original email?

	Arnd
