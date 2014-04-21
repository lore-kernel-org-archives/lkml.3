Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbaDUSfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 14:35:04 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57239 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbaDUSfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 14:35:01 -0400
Date: Mon, 21 Apr 2014 11:34:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Rich Felker <dalias@libc.org>, Jeff Layton <jlayton@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "Carlos O'Donell" <carlos@redhat.com>,
        libc-alpha <libc-alpha@sourceware.org>,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] locks: rename file-private locks to file-description
 locks
Message-ID: <20140421183439.GA17879@infradead.org>
References: <1398087935-14001-1-git-send-email-jlayton@redhat.com>
 <20140421140246.GB26358@brightrain.aerifal.cx>
 <535529FA.8070709@gmail.com>
 <20140421161004.GC26358@brightrain.aerifal.cx>
 <5355644C.7000801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5355644C.7000801@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 08:32:44PM +0200, Michael Kerrisk (man-pages) wrote:
> So, can you *please* answer this question: what do you call (i.e., 
> what  everyday technical language term do use for) the thing
> that sits between a file descriptor and an i-node? 

An open file.

