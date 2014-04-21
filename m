Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbaDUTHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 15:07:09 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33340 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbaDUTHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 15:07:02 -0400
Date: Mon, 21 Apr 2014 12:06:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Rich Felker <dalias@libc.org>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "Carlos O'Donell" <carlos@redhat.com>,
        libc-alpha <libc-alpha@sourceware.org>,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] locks: rename file-private locks to file-description
 locks
Message-ID: <20140421190659.GA10884@infradead.org>
References: <1398087935-14001-1-git-send-email-jlayton@redhat.com>
 <20140421140246.GB26358@brightrain.aerifal.cx>
 <535529FA.8070709@gmail.com>
 <20140421161004.GC26358@brightrain.aerifal.cx>
 <5355644C.7000801@gmail.com>
 <20140421184841.GA5105@thunk.org>
 <20140421185144.GF26358@brightrain.aerifal.cx>
 <20140421190410.GC5105@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140421190410.GC5105@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 03:04:10PM -0400, Theodore Ts'o wrote:
> I think what you mean is that there is no need that we expose the name
> "struct file".  My point is that "struct file" is actually a much
> _better_ name than "file description".  Heck, "open file object" would
> be better name than "file description".

Open file description is what all current standards use.  I'm pretty
sure really old ones just used open file, but struct file has never
been used in an API description.  Introducing it now entirely out of
context is not helpful at all.

