Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbaEZOCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 10:02:53 -0400
Received: from imap.thunk.org ([74.207.234.97]:32845 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbaEZOCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 10:02:52 -0400
Date: Mon, 26 May 2014 10:02:44 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, duanj.fnst@cn.fujitsu.com,
        fabf@skynet.be
Subject: Re: kernel-doc (was Re: + lib-digsigc-kernel-doc-warning-fixes.patch
 added to -mm tree)
Message-ID: <20140526140244.GC22284@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	duanj.fnst@cn.fujitsu.com, fabf@skynet.be
References: <CACVxJT82k0YO7eo8ECu3Rq__vu8L6TE2rhwVGoGLk_7nj+SYFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVxJT82k0YO7eo8ECu3Rq__vu8L6TE2rhwVGoGLk_7nj+SYFg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 04:27:04PM +0300, Alexey Dobriyan wrote:
> On Thu, May 22, 2014 at 10:28 PM,  <akpm@linux-foundation.org> wrote:
> >   * digsig_verify() - digital signature verification with public key
> >   * @keyring:   keyring to search key in
> >   * @sig:       digital signature
> > - * @sigen:     length of the signature
> > + * @siglen:    length of the signature
> >   * @data:      data
> >   * @datalen:   length of the data
> 
> Does anyone use kernel-doc generated documentation?
> I'm serious.

The kernel-doc generated documentation is available on the web, and I
suspect a number of people find it when they run Google Searches.

The danger of course is that they might get documentation which is out
of sync with the upstream kernel (or whatever kernel they are
developing against), but I know I've found it useful on occasion.

	   	     	   	     	   - Ted


