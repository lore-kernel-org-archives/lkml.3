Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab3KBRTx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 13:19:53 -0400
Received: from forward14.mail.yandex.net ([95.108.130.92]:60377 "EHLO
	forward14.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3KBRTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 13:19:50 -0400
From: =?koi8-r?B?8tXT1MHGwSDk1sHN1dLByM3F1M/X?= <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <87y556wxim.fsf@mina86.com>
References: <5083d6c8452b765cb33acdf03fa9b20b1d15c452.1382788496.git.mina86@mina86.com> <20131030155938.0f5416fe3c5c2cbd3f9cd319@linux-foundation.org> <xa1teh71iz3a.fsf@mina86.com> <212981383321699@web5m.yandex.ru> <20131101123041.d08adc9739cf6e733d822770@linux-foundation.org> <7061383365433@web15j.yandex.ru> <87y556wxim.fsf@mina86.com>
Subject: Re: [PATCH] drivers: w1: make w1_slave::flags long to avoid casts
MIME-Version: 1.0
Message-Id: <66721383412786@web21j.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sat, 02 Nov 2013 21:19:46 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

02.11.2013, 20:59, "Michal Nazarewicz" <mina86@mina86.com>:
>> šArgh, why would we just don't do that? Its in-memory field, it can be
>> šanything, I wouldn't be surprised if it even can be non-atomic because
>> šof proper locks already being held
>
> If the driver does not require an atomic set_bit operation for setting
> and testing the flag, feel free to prepare a patch replacing the whole
> thing with a plain bool.

Please make sure it is properly protected if it is ever required
