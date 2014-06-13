Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaFMVYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 17:24:14 -0400
Received: from kanga.kvack.org ([205.233.56.17]:36949 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbaFMVYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 17:24:13 -0400
Date: Fri, 13 Jun 2014 17:24:11 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: torvalds@linux-foundation.org
Cc: linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] *** SUBJECT HERE ***
Message-ID: <cover.1402694489.git.bcrl@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please pull the following 3 changes from git://git.kvack.org/~bcrl/aio-next.git
.  They consist of a couple of code cleanups plus a minor bug fix.  Thanks!

		-ben

Benjamin LaHaise (2):
  aio: report error from io_destroy() when threads race in io_destroy()
  aio: cleanup: flatten kill_ioctx()

Fabian Frederick (1):
  fs/aio.c: Remove ctx parameter in kiocb_cancel

 fs/aio.c | 70 +++++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 36 insertions(+), 34 deletions(-)

-- 
1.8.2.1


-- 
"Thought is the essence of where you are now."
