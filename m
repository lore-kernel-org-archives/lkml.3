Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbaBYW3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 17:29:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59849 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939AbaBYW31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 17:29:27 -0500
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 0/2] bdi fixes
Date: Tue, 25 Feb 2014 23:29:12 +0100
Message-Id: <1393367354-5172-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hello,

these two patches fix regressions caused by conversion from flusher
threads to standard workqueue. The first patch is an updated version of
Derek's fix, the second patch fixes a reliable oops on removal of a
device that is written to. I'm open to suggestions for a better fix in
case of the second patch but at least for 3.13 and stable kernels what I
did seemed good enough.

								Honza
