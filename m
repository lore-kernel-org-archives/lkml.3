Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab3HVAJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 20:09:18 -0400
Received: from forward4.mail.yandex.net ([77.88.46.9]:47026 "EHLO
	forward4.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab3HVAJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 20:09:17 -0400
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Aug 2013 20:09:16 EDT
From: Evgeniy Polyakov <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1377116673-31216-2-git-send-email-gregkh@linuxfoundation.org>
References: <1377116673-31216-1-git-send-email-gregkh@linuxfoundation.org> <1377116673-31216-2-git-send-email-gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2] w1: use default attribute groups for w1 slave devices
MIME-Version: 1.0
Message-Id: <267801377129759@web1d.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Thu, 22 Aug 2013 04:02:39 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Greg

22.08.2013, 00:24, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>:
> As we have 2 sysfs files for the w1 slave devices, let the driver core
> create / destroy them automatically by setting the default attribute
> group for them, saving code and housekeeping logic.
>
> Cc: Evgeniy Polyakov <zbr@ioremap.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Both patches look good, thanks a lot
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
