Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab3IJW3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:29:53 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45987 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752572Ab3IJW3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:29:52 -0400
Message-ID: <1378852189.23501.54.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 1/4] hpsa: add HP Smart Array Gen9 PCI ID's
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LKML-scsi <linux-scsi@vger.kernel.org>
Date: Tue, 10 Sep 2013 15:29:49 -0700
In-Reply-To: <48275AD710FCA34184C2B6186B4016B32D0FCEED@G6W2491.americas.hpqcorp.net>
References: <20130904200555.GA28147@beardog.cce.hp.com>
	 <1378850521.23501.47.camel@dabdike.int.hansenpartnership.com>
	 <48275AD710FCA34184C2B6186B4016B32D0FCEED@G6W2491.americas.hpqcorp.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-10 at 22:17 +0000, Miller, Mike (OS Dev) wrote:
> 
> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
> Sent: Tuesday, September 10, 2013 5:02 PM
> To: Miller, Mike (OS Dev)
> Cc: Andrew Morton; LKML; LKML-scsi
> Subject: Re: [PATCH 1/4] hpsa: add HP Smart Array Gen9 PCI ID's
> 
> On Wed, 2013-09-04 at 15:05 -0500, Mike Miller wrote:
> > Patch 1 of 4
> > 
> > From: Mike Miller <mike.miller@hp.com>
> 
> Just for future reference, doing it this way means I have to edit the patch.  The way git am works when applying patches is that if the first body line is a keyword it recognises (like From: or Subject: or Date:) it will fold that into the commit metadata, otherwise everything becomes the commit message.  So by putting the redundant "patch 1 of 4" first, git thinks the entire body is the commit message.
> 
> James
> 
> Sorry about that. I didn't realize git worked that way. So let me ask
> a dumb question, just having [PATCH x/y] in the subject line is
> enough?

Yes, that's what all the apply scripts go by.

>  Would you like me to resubmit the patchset?

No; I just edited the messages this time.

James


