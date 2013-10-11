Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab3JKX4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 19:56:24 -0400
Received: from fn.samba.org ([216.83.154.106]:59440 "EHLO mail.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab3JKX4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 19:56:21 -0400
X-Greylist: delayed 414 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Oct 2013 19:56:21 EDT
Date: Fri, 11 Oct 2013 16:49:23 -0700
From: Jeremy Allison <jra@samba.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: Andreas Dilger <adilger@dilger.ca>,
        "linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        samba-technical@lists.samba.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] locks: implement "filp-private" (aka UNPOSIX)
 locks
Message-ID: <20131011234923.GD8688@samba2>
Reply-To: Jeremy Allison <jra@samba.org>
References: <1381494322-2426-1-git-send-email-jlayton@redhat.com>
 <20131011200756.GB22160@fieldses.org>
 <EE732BCB-C38E-4874-AEDF-2EB9E1389A86@dilger.ca>
 <20131011192118.483e436f@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011192118.483e436f@tlielax.poochiereds.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Oct 2013 15:36:43 -0600 Andreas Dilger <adilger@dilger.ca> wrote:
> > 
> > At this point, my main questions are:
> > 
> > 1) does this look useful, particularly for fileserver implementors?

Yes from the Samba perspective. We'll have to keep the old
code around for compatibility with non-Linux OS'es, but this
will allow Linux Samba to short-circuit a bunch of logic
we have to get around the insane POSIX locking semantics
on close.

Jeremy.
