Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964947Ab3GLPwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 11:52:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933072Ab3GLPwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 11:52:50 -0400
From: Jan Vesely <jvesely@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-kernel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, Rob Evers <revers@redhat.com>,
        Tomas Henzl <thenzl@redhat.com>,
        Nikola Pajkovsky <npajkovs@redhat.com>,
        Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Don Howard <dhoward@redhat.com>
Subject: [PATCH v4 0/2] block: Allow merging of tail pages into the last segment
Date: Fri, 12 Jul 2013 17:52:21 +0200
Message-Id: <1373644343-6671-1-git-send-email-jvesely@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

These patches modify __bio_add_page to accept pages that extent the last bio
segment. some drivers craft their buffers and rely on this behavior (see
message in patch 2 for details)


jan

v4: whitespace fixes to make checkpatch happy

v3: Use code from __blk_recalc_rq_segments to decide whether the page is
    mergeable, 

v2: modify a comment


