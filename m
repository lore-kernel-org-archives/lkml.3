Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaKKCUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 21:20:17 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:53230 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaKKCUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 21:20:12 -0500
From: David Fries <David@Fries.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATHC 0/2] cn: w1: buffer size checks
Date: Mon, 10 Nov 2014 20:19:35 -0600
Message-Id: <1415672377-18758-1-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <18541415578350@web5g.yandex.ru>
References: <18541415578350@web5g.yandex.ru>
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Mon, 10 Nov 2014 20:19:51 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman,
These issues were found by Dan Carpenter with a static checker and will check
message buffer lengths from userspace or avoid length overflows.  Evgeniy
Polyakov has given his ack, and they can be applied to the stable branch as
well.

[PATCH 1/2] cn: verify msg->len before making callback
[PATCH 2/2] w1: avoid potential u16 overflow
