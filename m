Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3FLE0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 00:26:50 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:54384 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3FLE0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 00:26:48 -0400
Date: Tue, 11 Jun 2013 21:26:55 -0700
From: Kent Overstreet <koverstreet@google.com>
To: dsterba@suse.cz, axboe@kernel.dk, tytso@mit.edu,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>,
        dm-devel@redhat.com
Subject: Re: [PATCH 22/26] block: Make generic_make_request handle arbitrary
 sized bios
Message-ID: <20130612042655.GA8650@moria.home.lan>
References: <1370744348-15407-1-git-send-email-koverstreet@google.com>
 <1370744348-15407-23-git-send-email-koverstreet@google.com>
 <20130611171241.GA5316@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130611171241.GA5316@twin.jikos.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 07:12:41PM +0200, David Sterba wrote:
> On Sat, Jun 08, 2013 at 07:19:04PM -0700, Kent Overstreet wrote:
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -467,6 +468,7 @@ struct request_queue {
> >  #define QUEUE_FLAG_SECDISCARD  17	/* supports SECDISCARD */
> >  #define QUEUE_FLAG_SAME_FORCE  18	/* force complete on same CPU */
> >  #define QUEUE_FLAG_DEAD        19	/* queue tear-down finished */
> > +#define QUEUE_FLAG_LARGEBIOS   19	/* no limits on bio size */
>                                   ^^
> 				  20 ?
> 
> david

Whoops! Thanks, fixed.
