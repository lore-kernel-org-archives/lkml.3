Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab3GVUMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 16:12:50 -0400
Received: from forward8.mail.yandex.net ([77.88.61.38]:56418 "EHLO
	forward8.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880Ab3GVUMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 16:12:49 -0400
X-Greylist: delayed 721 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jul 2013 16:12:49 EDT
From: Evgeniy Polyakov <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: Jingoo Han <jg1.han@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        GregKH <greg@kroah.com>
In-Reply-To: <001401ce844f$d4047db0$7c0d7910$@samsung.com>
References: <001401ce844f$d4047db0$7c0d7910$@samsung.com>
Subject: Re: [PATCH] w1: replace strict_strtol() with kstrtol()
MIME-Version: 1.0
Message-Id: <1435421374523244@web23e.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 23 Jul 2013 00:00:44 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone

19.07.2013, 11:16, "Jingoo Han" <jg1.han@samsung.com>:
> The usage of strict_strtol() is not preferred, because
> strict_strtol() is obsolete. Thus, kstrtol() should be
> used.

Looks good to me, although I do not really see the difference
Greg, please pull into your tree or suggest appropriate.

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
