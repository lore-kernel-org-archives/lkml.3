Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaJYU6J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 16:58:09 -0400
Received: from forward15.mail.yandex.net ([95.108.130.119]:36021 "EHLO
	forward15.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbaJYU5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 16:57:55 -0400
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Oct 2014 16:57:55 EDT
From: =?koi8-r?B?5dfHxc7JyiDwz8zRy8/X?= <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: Alexander Stein <alexanders83@web.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Fries <david@fries.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
In-Reply-To: <1414239973-4819-1-git-send-email-alexanders83@web.de>
References: <1414239973-4819-1-git-send-email-alexanders83@web.de>
Subject: Re: [PATCH 1/1] W1: ds2490: Increase timeout when waiting for status
MIME-Version: 1.0
Message-Id: <1795801414270117@web29j.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sun, 26 Oct 2014 00:48:37 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone

This looks good to me
Greg, please pull it into your tree

Thank you

25.10.2014, 16:27, "Alexander Stein" <alexanders83@web.de>:
> Adjust the bulk message timeout to the other ones (1000ms). Otherwise the
> following dmesg errors can be seen on a Raspberry Pi:
> [ šš31.492386] Failed to read 1-wire data from 0x81: err=-110.
> [ šš31.504168] 0x81: count=-110, status:
> [ šš31.613404] Failed to read 1-wire data from 0x81: err=-110.
> [ šš31.621915] 0x81: count=-110, status:
> [ šš43.260968] Failed to read 1-wire data from 0x81: err=-110.
> [ šš43.270998] 0x81: count=-110, status:
> [ šš43.379959] Failed to read 1-wire data from 0x81: err=-110.
> [ šš43.388854] 0x81: count=-110, status:
>
> Signed-off-by: Alexander Stein <alexanders83@web.de>

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
