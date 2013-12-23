Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab3LWPiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 10:38:04 -0500
Received: from forward19.mail.yandex.net ([95.108.253.144]:56607 "EHLO
	forward19.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab3LWPiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 10:38:01 -0500
From: =?koi8-r?B?5NbBzdXSwcjNxdTP1yDy1dPUwcbB?= <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Levente Kurusa <levex@linux.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20131218234743.GB14527@kroah.com>
References: <1386962557-8899-1-git-send-email-levex@linux.com>
 <1386962557-8899-5-git-send-email-levex@linux.com>
 <216611387034229@web23g.yandex.ru> <20131218234743.GB14527@kroah.com>
Subject: Re: [PATCH 4/4] w1: call put_device if device_register fails
MIME-Version: 1.0
Message-Id: <85861387813077@web7g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 23 Dec 2013 19:37:57 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

19.12.2013, 03:47, "Greg KH" <gregkh@linuxfoundation.org>:

> I don't seem to have this patch anywhere, can someone please resend it
> to me?

Andrew Morton picked it up

http://www.spinics.net/lists/mm-commits/msg101101.html
