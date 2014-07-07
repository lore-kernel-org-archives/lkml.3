Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaGGSwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:52:22 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:54100 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbaGGSwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:52:20 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 0/3] mm: memcontrol: rewrite uncharge API follow-up fixes
Date: Mon,  7 Jul 2014 14:52:10 -0400
Message-Id: <1404759133-29218-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

here are 3 fixlets on top of the memcg uncharge rewrite, two of which
based on problems that Hugh reported.  They should apply directly on
top of the existing fixlets for "mm: memcontrol: rewrite uncharge API".

Thanks!

