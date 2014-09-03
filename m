Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333AbaICEEO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 00:04:14 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:60688 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaICEEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 00:04:13 -0400
MIME-Version: 1.0
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 3 Sep 2014 00:03:41 -0400
Message-ID: <CAJhHMCDMuByuTdOwTscZ0tF3WopYrqfYnRD=5sPHXGQZZu09wg@mail.gmail.com>
Subject: Bogus error in checkpatch.pl
To: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I receive an ERROR when running checkpatch.pl on a patch containing
the following line:

Commit 615cc2c9cf95 "Documentation/memory-barriers.txt: fix important typo re

saying that the commit ID should be 12 or more characters when the
commit ID is indeed 12 characters. I tried fixing it, but my perl is
not up-to-par.

Please fix! Thanks.

-- 
Pranith
