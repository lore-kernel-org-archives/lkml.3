Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab3HaPzd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 11:55:33 -0400
Received: from forward16.mail.yandex.net ([95.108.253.141]:55492 "EHLO
	forward16.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3HaPzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 11:55:32 -0400
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Aug 2013 11:55:31 EDT
From: Evgeniy Polyakov <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: Jingoo Han <jg1.han@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <002e01cea537$c9b15730$5d140590$%han@samsung.com>
References: <002e01cea537$c9b15730$5d140590$%han@samsung.com>
Subject: Re: [PATCH 1/2] w1: w1-gpio: use dev_get_platdata()
MIME-Version: 1.0
Message-Id: <158441377964182@web28g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sat, 31 Aug 2013 19:49:42 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

30.08.2013, 08:17, "Jingoo Han" <jg1.han@samsung.com>:
> Use the wrapper function for retrieving the platform data instead of
> accessing dev->platform_data directly. This is a cosmetic change
> to make the code simpler and enhance the readability.

Both patches look good, thank you

> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
