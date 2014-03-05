Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038AbaCEUK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 15:10:27 -0500
Received: from authsmtp01.uchicago.edu ([128.135.12.121]:55532 "EHLO
	authsmtp01.uchicago.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728AbaCEUKZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 15:10:25 -0500
X-Greylist: delayed 1772 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Mar 2014 15:10:25 EST
MIME-Version: 1.0
From: Tiratat Patana-anake <tiratatp@uchicago.edu>
Date: Wed, 5 Mar 2014 13:40:26 -0600
Message-ID: <CAG9uKVWgL95qFrTBa6v8NZoR4JP+wXY4-RAOBwKm1r2XweOjbA@mail.gmail.com>
Subject: Problem with JDB and per-BDI writeback
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a question about JDB and per-BDI writeback on ext3 file system.
I saw that in ext3_*_write_end function (e.g. ext3_ordered_write_end
and ext3_journalled_write_end),
the inode was added to superblock's dirty list for a writeback.

For data=journal journalling, it doesn't make sense to me.
Since the journal will handle the write to the real sector on disk
during checkpointing.

What am I missing here?

Thank you for your help.

My name is Tiratat. I'm a PhD student from University of Chicago.
I'm working on a project that will try to do selective journaling for
random writes.

Best Regards
Tiratat

--
Tiratat (Knot) Patana-anake
ถิรธัช (น้อต) พัฒนะเอนก
