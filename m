Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760226Ab3B0Pzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 10:55:48 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44825 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758651Ab3B0Pzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 10:55:46 -0500
Date: Wed, 27 Feb 2013 16:55:39 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: Re: EXT4 corruption on Linus latest tree.
Message-ID: <20130227155539.GA2638@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
References: <20130227154311.GA12450@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130227154311.GA12450@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 10:43:11AM -0500, Dave Jones wrote:
> Built from a pull around midnight EST last night.
> (Don't have the git hash, as the source is on the disk that is now inaccessable..)
> 
> EXT4-fs error (device sdb1): htree_dirblock_to_tree:919: inode #172235804: block 152052301: comm ls: bad entry in directory: rec_len is smaller than minimal - offset=0(0), inode=0, rec_len=0, name_len=0
> EXT4-fs error (device sdb1): htree_dirblock_to_tree:919: inode #172235804: block 152052301: comm ls: bad entry in directory: rec_len is smaller than minimal - offset=0(0), inode=0, rec_len=0, name_len=0
> EXT4-fs error (device sdb1): htree_dirblock_to_tree:919: inode #172235804: block 152052301: comm ls: bad entry in directory: rec_len is smaller than minimal - offset=0(0), inode=0, rec_len=0, name_len=0
> EXT4-fs error (device sdb1): htree_dirblock_to_tree:919: inode #172235381: block 152052288: comm ls: bad entry in directory: rec_len is smaller than minimal - offset=0(0), inode=0, rec_len=0, name_len=0
> EXT4-fs error (device sdb1): htree_dirblock_to_tree:919: inode #172228609: block 152051744: comm ls: bad entry in directory: rec_len is smaller than minimal - offset=0(0), inode=0, rec_len=0, name_len=0
> 
> This is a 3TB disk which has 1.9TB used.
> 
> I can see some files/dirs, but some top level dirs now appear empty.
> 
> About to reboot back to a safe kernel and fsck.

Hmm, more people triggering something like that:
http://marc.info/?l=linux-kernel&m=136196926015305&w=2

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
