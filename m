Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab3BUNhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 08:37:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41411 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558Ab3BUNhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 08:37:34 -0500
Message-ID: <5126231C.6060507@suse.de>
Date: Thu, 21 Feb 2013 14:37:32 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>
Subject: Re: New copyfile system call - discuss before LSF?
References: <512606DF.5050706@redhat.com>
In-Reply-To: <512606DF.5050706@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 12:37 PM, Ric Wheeler wrote:
>
> We have debated the need to have a system call to allow for
> offloading copy operations, for example to an NFS server (part to
> the new NFS 4.2 specification), SCSI target device (two different
> SCSI commands do this), local file systems (reflink, etc) and I
> suspect many other possible parts of the stack could implement this.
>
> The earliest discussion of such a system call I saw happened back in
> 2001, I know we had another more recent flurry (2-3 years back?) as
> well that got tangled up and died away.
>
Yeah, I remember. I talked to Mkp about it, who (as usual :-) had a 
patchset stashed away for this.
Or a preliminary attempt, anyway.
However, this was waiting for the DISCARD merging patches to go in, 
which in turn were waiting for the WRITE SAME patches IIRC.

Or something.

Martin?

> Given the new popularity of this in storage devices and the use case
> for virt guests, any chance to get a proposal floated this year that
> might be able to land upstream in our life times :) ?
>
Oh, most definitely.
Now that I finally have an array capable of doing ROD token copy
we should be reevaluating things.

I see to have the sg_xcopy program updated to do ROD copy, then we 
will have some real-world data.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
