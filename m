Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaKJAMf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 19:12:35 -0500
Received: from forward18.mail.yandex.net ([95.108.253.143]:42870 "EHLO
	forward18.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbaKJAMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 19:12:34 -0500
From: =?koi8-r?B?5dfHxc7JyiDwz8zRy8/X?= <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: David Fries <david@fries.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Kees Cook <keescook@chromium.org>
In-Reply-To: <1415572634-12303-1-git-send-email-David@Fries.net>
References: <1415572634-12303-1-git-send-email-David@Fries.net>
Subject: Re: [PATHC 0/2] cn: w1: buffer size checks
MIME-Version: 1.0
Message-Id: <18541415578350@web5g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 10 Nov 2014 03:12:30 +0300
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

10.11.2014, 01:37, "David Fries" <David@Fries.net>:
> These issues were found by Dan Carpenter with a static checker.
> Evgeniy are you okay with these?
>
> [PATCH 1/2] cn: verify msg->len before making callback
> [PATCH 2/2] w1: avoid potential u16 overflow

Both patches look good, thank you
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
