Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab3HVAJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 20:09:29 -0400
Received: from forward1.mail.yandex.net ([77.88.46.6]:51070 "EHLO
	forward1.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab3HVAJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 20:09:27 -0400
From: =?koi8-r?B?8tXT1MHGwSDk1sHN1dLByM3F1M/X?= <drustafa@yandex.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1377125105-25388-1-git-send-email-gregkh@linuxfoundation.org>
References: <1377125105-25388-1-git-send-email-gregkh@linuxfoundation.org>
Subject: Re: [PATCH 01/11] w1: add attribute groups to struct w1_family_ops
MIME-Version: 1.0
Message-Id: <267911377129904@web1d.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Thu, 22 Aug 2013 04:05:04 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

22.08.2013, 02:45, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>:
> This lets w1 slave drivers declare an attribute group, and not have to
> create/destroy sysfs files directly. šAll w1 slave drivers will be fixed
> to use this field up in follow-on patches to this one.

Sounds reasonble, saves fair amount of code in w1 drivers

> Cc: Evgeniy Polyakov <zbr@ioremap.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-core-and-particular-w1-drivers-by: Evgeniy Polyakov <zbr@ioremap.net>
