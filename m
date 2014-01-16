Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaAPOtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 09:49:05 -0500
Received: from fieldses.org ([174.143.236.118]:58375 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbaAPOtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 09:49:02 -0500
Date: Thu, 16 Jan 2014 09:48:56 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Zach Brown <zab@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>
Subject: Re: [PATCH 11/11] ext4: add cross rename support
Message-ID: <20140116144856.GA16829@fieldses.org>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
 <1389219015-10980-12-git-send-email-miklos@szeredi.hu>
 <20140113122517.GA10366@quack.suse.cz>
 <20140115182347.GB5715@fieldses.org>
 <CAJfpegv0TgJpd-pXxBj2n0efRUW9_GW_tYtHtfN6drOYA=25QQ@mail.gmail.com>
 <20140116105406.GF24171@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140116105406.GF24171@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 11:54:06AM +0100, Miklos Szeredi wrote:
> > On Wed, Jan 15, 2014 at 7:23 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> > > Do you have a man page update somewhere for the two new flags?
> 
> Here's the updated man page (and attached the patch)

Looks good to me.  Total nits:

>        RENAME_NOREPLACE
>               Don't  overwrite  the  target of the rename.  Return an error if
>               the target would be overwritten.

s/Return an error/Fail with EEXIST/?

(Since it doesn't literally return the error.)

>        ENOENT flags contain RENAME_EXCHANGE and the target of the rename  does
>               not exist

s/the target of the rename/either of the two files/

--b.
