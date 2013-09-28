Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab3I1WPS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 18:15:18 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:52481 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab3I1WPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 18:15:17 -0400
Date: Sat, 28 Sep 2013 18:15:13 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: [PATCHSET] sysfs: use seq_file and unify regular and bin file
 handling
Message-ID: <20130928221513.GA20640@htj.dyndns.org>
References: <1380404984-31858-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380404984-31858-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, again.

On Sat, Sep 28, 2013 at 05:49:30PM -0400, Tejun Heo wrote:
>  0001-sysfs-remove-unused-sysfs_buffer-pos.patch
>  0002-sysfs-remove-sysfs_buffer-needs_read_fill.patch
>  0003-sysfs-remove-sysfs_buffer-ops.patch
>  0004-sysfs-add-sysfs_open_file_mutex.patch
>  0005-sysfs-rename-sysfs_buffer-to-sysfs_open_file.patch
>  0006-sysfs-add-sysfs_open_file-sd-and-file.patch
>  0007-sysfs-use-transient-write-buffer.patch
>  0008-sysfs-use-seq_file-when-reading-regular-files.patch
>  0009-sysfs-prepare-llseek-path-for-unified-regular-bin-fi.patch
>  0010-sysfs-prepare-path-write-for-unified-regular-bin-fil.patch
>  0011-sysfs-prepare-read-path-for-unified-regular-bin-file.patch
>  0012-sysfs-copy-bin-mmap-support-from-fs-sysfs-bin.c-to-f.patch
>  0013-sysfs-prepare-open-path-for-unified-regular-bin-file.patch
>  0014-sysfs-merge-regular-and-bin-file-handling.patch

On the second thought, 0011 seems too dangerous, especially for pci IO
BAR regions.  Grumble, looks like I'll have to break out the bin read
path.  Please ignore patches >= 0009.  I'll update them and repost.

Thanks!

-- 
tejun
