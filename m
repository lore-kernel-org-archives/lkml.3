Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab3KXRMV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 12:12:21 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:43170 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab3KXRMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 12:12:19 -0500
MIME-Version: 1.0
Date: Sun, 24 Nov 2013 09:12:18 -0800
Message-ID: <CAJusiZW1U93-wS0kPkSQprj+BzXVz29078mCaQ8zt39AB0gvuQ@mail.gmail.com>
Subject: AF_ALG does not work with sendfile()
From: Shawn Landden <shawnlandden@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, linux-crypto@vget.kernel.org,
        herbert@gondor.hengli.com.au
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If I use sendfile() to send to a accept()ed AF_ALG socket set up for
"hash", I get the wrong
answer, if I read() and then write() I get the right answer. None of
the system calls return an error.
---
Shawn Landden
+1 360 389 3001 (SMS preferred)
