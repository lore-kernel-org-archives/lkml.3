Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423088Ab3DFPDk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 11:03:40 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:44029 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758112Ab3DFPDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 11:03:38 -0400
Message-ID: <51603799.9070008@gmail.com>
Date: Sat, 06 Apr 2013 16:56:25 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Steve French <sfrench@samba.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Anton Altaparmakov <anton@tuxera.com>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <jlbec@evilplan.org>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, xfs@oss.sgi.com,
        Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net,
        linux-ntfs-dev@lists.sourceforge.net, ocfs2-devel@oss.oracle.com,
        linux-mm@kvack.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/4] fsfreeze: manage kill signal when sb_start_write
 is called
References: <515FF344.8040705@gmail.com> <20130406131703.GC28744@parisc-linux.org>
In-Reply-To: <20130406131703.GC28744@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/04/2013 15:17, Matthew Wilcox ha scritto:
> On Sat, Apr 06, 2013 at 12:04:52PM +0200, Marco Stornelli wrote:
>> In every place where sb_start_write was called now we must manage
>> the error code and return -EINTR.
>
> If we must manage the error code, then these functions should be marked
> __must_check.
>

Yep, good point.

Marco
