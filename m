Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054Ab3JOQPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 12:15:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51338 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437Ab3JOQPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 12:15:07 -0400
Date: Tue, 15 Oct 2013 17:15:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext[34]: fix double put in tmpfile
Message-ID: <20131015161505.GM13318@ZenIV.linux.org.uk>
References: <20131010144819.GA16642@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010144819.GA16642@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 04:48:19PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> d_tmpfile() already swallowed the inode ref.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Cc: stable@vger.kernel.org

Applied.
