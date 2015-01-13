Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbbAMRJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:09:37 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46143 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbbAMRJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:09:35 -0500
Date: Tue, 13 Jan 2015 17:09:32 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: jesper.nilsson@axis.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-cris-kernel@axis.com
Subject: Re: [PATCH] VFS: Convert file->f_dentry->d_inode to file_inode()
Message-ID: <20150113170932.GI22149@ZenIV.linux.org.uk>
References: <20150113163832.24625.95960.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113163832.24625.95960.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 04:38:32PM +0000, David Howells wrote:
> Convert file->f_dentry->d_inode to file_inode() so as to get layered
> filesystems right.
> 
> Found with: git grep '[.>]f_dentry'

ACK.  I wonder how that got missed during f_dentry elimination - even the
macro is gone these days...
