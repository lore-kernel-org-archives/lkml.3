Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbaBKVAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:00:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:52805 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbaBKVAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:00:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH 02/12] power/reset: vexpress: Use udelay instead of timers
Date: Tue, 11 Feb 2014 21:59:16 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com> <1392138636-29240-3-git-send-email-pawel.moll@arm.com>
In-Reply-To: <1392138636-29240-3-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201402112159.16758.arnd@arndb.de>
X-Provags-ID: V02:K0:aoJQdhzfzpop04MAKwkgy0FsrDgHUXxZqYHsVDP9/Oh
 YOysJbBnJZUaN2i3GordgWu9wHgqAyteQ+BhCnVvlj/wH6QTZN
 CfxsUD8SIjVsAZpNDYNVuWFLNzkFeNXskdpfaAlB9KkOCTEsQL
 8DlTGzwC9IEXWuEr05NAY941qYJTu2QCyf4oJPiWU6nVuvCws8
 wOYrZmmG8WI5eEyCPjO7P9cznENBi6A0q4eCK/qo0KD6nCdIch
 TrP3KQpSB9J3zNAiJVO+bL5tkvC9B5vvbJIHo38yuKlOIZR40Y
 bIItIbGktm3i0B7oRbAOdP1jsSkLeQHfdG7J2wJvZH0yf1SDI3
 mXg/x5tdLGMVi8fb+umE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 February 2014, Pawel Moll wrote:
> At this stage of system shutdown procedure the jiffies may
> not be updated anymore, so just use udelay instead.

comment doesn't match code: s/udelay/mdelay/

> +                       mdelay(1000);
>         }

	Arnd
