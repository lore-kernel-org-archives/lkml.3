Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab3LNPRO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 10:17:14 -0500
Received: from forward16.mail.yandex.net ([95.108.253.141]:47038 "EHLO
	forward16.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab3LNPRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 10:17:13 -0500
From: Evgeniy Polyakov <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: Levente Kurusa <levex@linux.com>, LKML <linux-kernel@vger.kernel.org>
Cc: GregKH <greg@kroah.com>
In-Reply-To: <1386962557-8899-5-git-send-email-levex@linux.com>
References: <1386962557-8899-1-git-send-email-levex@linux.com> <1386962557-8899-5-git-send-email-levex@linux.com>
Subject: Re: [PATCH 4/4] w1: call put_device if device_register fails
MIME-Version: 1.0
Message-Id: <216611387034229@web23g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sat, 14 Dec 2013 19:17:09 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

13.12.2013, 23:23, "Levente Kurusa" <levex@linux.com>:
> Currently, memsetting and kfreeing the device is bad behaviour.
> The device will have a reference count of 1 and hence can cause trouble
> because it has kfree'd. Proper way to handle a failed device_register
> is to call put_device right after it fails.

Looks good to me, thank you
Greg, please pull it into your treee

> Signed-off-by: Levente Kurusa <levex@linux.com>

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
