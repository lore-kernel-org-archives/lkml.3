Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935507Ab3BTOhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 09:37:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933182Ab3BTOhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 09:37:19 -0500
From: Peter Jones <pjones@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Matt Fleming <matt.fleming@intel.com>, Jens Axboe <axboe@kernel.dk>,
        Stephen Warren <swarren@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: linux-next: build warning after merge of the akpm tree
Date: Wed, 20 Feb 2013 09:37:00 -0500
Message-Id: <1361371021-583-1-git-send-email-pjones@redhat.com>
In-Reply-To: <20130220173414.fa4886355efd8f85d0d349f4@canb.auug.org.au>
References: <20130220173414.fa4886355efd8f85d0d349f4@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

The following email is an updated patch which should fix the warning you're
seeing on architectures where sizeof is unsigned int rather than unsigned
long.

This completely replaces the ef25bb0fa6e2 patch.  Andrew, if you'd prefer a
single-line fixup patch, I can send you that instead.


