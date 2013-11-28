Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719Ab3K1QY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 11:24:56 -0500
Received: from forward1m.mail.yandex.net ([37.140.138.1]:39149 "EHLO
	forward1m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3K1QYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 11:24:51 -0500
From: =?koi8-r?B?8tXT1MHGwSDk1sHN1dLByM3F1M/X?= <drustafa@yandex.ru>
To: Jingoo Han <jg1.han@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <005801ceebf3$f3695570$da3c0050$%han@samsung.com>
References: <004e01ceebec$52ed0f80$f8c72e80$%han@samsung.com> <005801ceebf3$f3695570$da3c0050$%han@samsung.com>
Subject: Re: [PATCH] w1: matrox: use DEFINE_PCI_DEVICE_TABLE macro
MIME-Version: 1.0
Message-Id: <22321385655887@web21m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Thu, 28 Nov 2013 20:24:47 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

28.11.2013, 08:40, "Jingoo Han" <jg1.han@samsung.com>:

> "Yeah, and it's a horrid macro that deserves to be removed, please don't
> use it in more places.
>
> Actually, if you could just remove it, that would be best, sorry, I'm
> not going to take these patches."
>
> So, I will send the patch to remove 'DEFINE_PCI_DEVICE_TABLE' instead.
> Sorry for annoying. :-)

No problem :)
Thanks for noticing this issue
