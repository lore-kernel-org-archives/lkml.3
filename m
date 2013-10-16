Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760878Ab3JPQSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 12:18:35 -0400
Received: from forward4h.mail.yandex.net ([84.201.186.22]:42952 "EHLO
	forward4h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab3JPQSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 12:18:33 -0400
From: =?koi8-r?B?8tXT1MHGwSDk1sHN1dLByM3F1M/X?= <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1381649007-3429-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1381649007-3429-1-git-send-email-michael.opdenacker@free-electrons.com>
Subject: Re: [PATCH] w1: ds1wm: remove deprecated IRQF_DISABLED
MIME-Version: 1.0
Message-Id: <166871381940310@web26h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 16 Oct 2013 20:18:30 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

13.10.2013, 11:23, "Michael Opdenacker" <michael.opdenacker@free-electrons.com>:
> This patch proposes to remove the use of the IRQF_DISABLED flag
>
> It's a NOOP since 2.6.35 and it will be removed one day.
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Both patches look good, thank you
Greg, please pull them into your tree

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
