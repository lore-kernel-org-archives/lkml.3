Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760896Ab3JPQZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 12:25:27 -0400
Received: from forward1h.mail.yandex.net ([84.201.187.146]:50226 "EHLO
	forward1h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018Ab3JPQZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 12:25:22 -0400
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Oct 2013 12:25:22 EDT
From: Evgeniy Polyakov <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <166871381940310@web26h.yandex.ru>
References: <1381649007-3429-1-git-send-email-michael.opdenacker@free-electrons.com> <166871381940310@web26h.yandex.ru>
Subject: Re: [PATCH] w1: ds1wm: remove deprecated IRQF_DISABLED
MIME-Version: 1.0
Message-Id: <168431381940381@web26h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 16 Oct 2013 20:19:41 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

13.10.2013, 11:23, "Michael Opdenacker" <michael.opdenacker@free-electrons.com>:
> šThis patch proposes to remove the use of the IRQF_DISABLED flag
>
> šIt's a NOOP since 2.6.35 and it will be removed one day.
>
> šSigned-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Both patches look good, thank you
Greg, please pull them into your tree

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
