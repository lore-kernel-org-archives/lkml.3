Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab3FGXvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:51:47 -0400
Received: from smtp.outflux.net ([198.145.64.163]:34623 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756759Ab3FGXvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:51:44 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        David Woodhouse <dwmw2@infradead.org>,
        Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH v2 0/6] format string usage clean ups
Date: Fri,  7 Jun 2013 16:50:49 -0700
Message-Id: <1370649055-12830-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 2 of this series. Originally: https://lkml.org/lkml/2013/6/6/614

Changes:
 - "power: ensure event is not used as format string" taken by maintainer.
 - "kobject: sanitize argument for format string" taken by maintainer.
 - "device: avoid format string in dev_set_name" fixed for newly uncovered
   additional error in format string.
 - "isdn: clean up debug format string usage" accidental dev_set_name
   revert chunk dropped.

Thanks,

-Kees

