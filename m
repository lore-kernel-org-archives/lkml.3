Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab3KZDdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 22:33:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab3KZDdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 22:33:21 -0500
Date: Mon, 25 Nov 2013 19:34:06 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mikhail Pershin <mike.pershin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH 02/16] staging/lustre/llog: MGC to use OSD API for backup
 logs
Message-ID: <20131126033406.GA8814@kroah.com>
References: <1385431510-18988-1-git-send-email-bergwolf@gmail.com>
 <1385431510-18988-3-git-send-email-bergwolf@gmail.com>
 <20131126031408.GA3666@kroah.com>
 <CA+a=Yy4KuGugnCGcofNbKsWV6DsCYt_GVMPyjo9nsyasm9cp7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+a=Yy4KuGugnCGcofNbKsWV6DsCYt_GVMPyjo9nsyasm9cp7w@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 11:25:24AM +0800, Peng Tao wrote:
> On Tue, Nov 26, 2013 at 11:14 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Tue, Nov 26, 2013 at 10:04:56AM +0800, Peng Tao wrote:
> >> From: Mikhail Pershin <mike.pershin@intel.com>
> >>
> >> MGC uses lvfs API to access local llogs blocking removal of old code
> >>
> >> - MGS is converted to use OSD API for local llogs
> >> - llog_is_empty() and llog_backup() are introduced
> >> - initial OSD start initialize run ctxt so llog can use it too
> >> - shrink dcache after initial scrub in osd-ldiskfs to avoid holding
> >>   data of unlinked objects until umount.
> >
> > It is not checkpatch clean :(
> >
> > Come on, it's not hard to do this yourself, why do you make me find
> > these errors for you?  It does nothing but make me not want to look at
> > lustre patches for a long time...
> 
> Strange. I did run checkpatch before sending the patchset out.
> 
> Just tried again. Still pass.
> 
> [X61@linux-lustre]$./scripts/checkpatch.pl
> 0002-staging-lustre-llog-MGC-to-use-OSD-API-for-backup-lo.patch total:
> 0 errors, 0 warnings, 883 lines checked
> 
> 0002-staging-lustre-llog-MGC-to-use-OSD-API-for-backup-lo.patch has no
> obvious style problems and is ready for submission.
> 
> What message did you see?

One about return();

greg k-h
