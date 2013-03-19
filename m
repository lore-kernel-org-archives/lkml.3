Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab3CSDgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 23:36:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab3CSDgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 23:36:00 -0400
Date: Mon, 18 Mar 2013 23:35:55 -0400
From: Dave Jones <davej@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: ext4_block_to_path block > max warning.
Message-ID: <20130319033555.GA1582@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure what I did to trigger this, but it's happened a few times while fuzzing syscalls.
Rebooted and fscked, didn't find anything wrong.

	Dave

[ 5084.436288] EXT4-fs warning (device sda1): ext4_block_to_path:105: block 1874853625 > max in inode 34
[ 5167.723925] EXT4-fs warning (device sda1): ext4_block_to_path:105: block 2507988634 > max in inode 34
[ 5658.991264] EXT4-fs warning (device sda1): ext4_block_to_path:105: block 3875035633 > max in inode 83
[ 5812.807999] EXT4-fs warning (device sda1): ext4_block_to_path:105: block 4159504181 > max in inode 28
[ 5818.715342] EXT4-fs warning (device sda1): ext4_block_to_path:105: block 2528932189 > max in inode 28
[ 5858.709967] EXT4-fs warning (device sda1): ext4_block_to_path:105: block 4250347255 > max in inode 28

