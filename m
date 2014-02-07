Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbaBGRgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:36:43 -0500
Received: from fieldses.org ([174.143.236.118]:57584 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbaBGRgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:36:41 -0500
Date: Fri, 7 Feb 2014 12:36:36 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, dhowells@redhat.com,
        zab@redhat.com, jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: Re: [PATCH 01/13] vfs: add d_is_dir()
Message-ID: <20140207173636.GA8801@fieldses.org>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
 <1391791751-2533-2-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391791751-2533-2-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 05:48:59PM +0100, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Add d_is_dir(dentry) helper which is analogous to S_ISDIR().

While trying to get up to speed I notice that these flags were
introduced by b18825a7c8e37a7cf6abb97a12a6ad71af160de7 "VFS: Put a small
type field into struct dentry::d_flags" whose changelog tells me "what"
but not "why".  So out of curiosity: was that some kind of optimization,
or was there some other reason for it?

--b.
