Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab3KAQGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:06:34 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:15164 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab3KAQGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:06:33 -0400
Subject: [PATCH] cciss: return 0 from driver probe function on success, not 1
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org,
        thenzl@redhat.com
Date: Fri, 01 Nov 2013 11:06:32 -0500
Message-ID: <20131101160528.17867.59655.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just resending the patch with a better change log message (as requested
by Andrew Morton) and cc'ing stable@vger.kernel.org, (as I originally
had intended.)

---

Stephen M. Cameron (1):
      cciss: return 0 from driver probe function on success, not 1


 drivers/block/cciss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
-- steve
