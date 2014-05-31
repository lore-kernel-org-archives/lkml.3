Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbaEaMZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 08:25:27 -0400
Received: from forward4m.mail.yandex.net ([37.140.138.4]:43257 "EHLO
	forward4m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbaEaMZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 08:25:25 -0400
From: Evgeniy Polyakov <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: Thomas Wood <tommyandrena@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        GregKH <greg@kroah.com>
In-Reply-To: <1401491420-6953-1-git-send-email-tommyandrena@gmail.com>
References: <1401491420-6953-1-git-send-email-tommyandrena@gmail.com>
Subject: Re: [PATCH] drivers/w1/w1_int.c: Fix style errors.
MIME-Version: 1.0
Message-Id: <2069611401539121@web10m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sat, 31 May 2014 16:25:21 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas

31.05.2014, 03:11, "Thomas Wood" <tommyandrena@gmail.com>:
> Replace spaces at beginning of the string with tabs, and replace foo * bar with foo *bar in a pointer declaration.
>
> Signed-off-by: Thomas Wood <tommyandrena@gmail.com>

Looks good, thank you.
Greg, please pull it into your tree or suggest appropriate.

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
