Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198AbaLQPEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 10:04:50 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:52362 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaLQPEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 10:04:48 -0500
Date: Wed, 17 Dec 2014 07:04:43 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: DuDudley <dudlx@outlook.com>
Cc: Dudley Du <dudl@cypress.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        "bleung@google.com" <bleung@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Solda <dso@cypress.com>
Subject: Re: [PATCH v16 01/12] input: cyapa: re-design driver to support
Message-ID: <20141217150443.GB3895@newt.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	DuDudley <dudlx@outlook.com>, Dudley Du <dudl@cypress.com>,
	"dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
	"rydberg@euromail.se" <rydberg@euromail.se>,
	"bleung@google.com" <bleung@google.com>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	David Solda <dso@cypress.com>
References: <BAY407-EAS4239EB7A931AAE7C4C747F3BD6D0@phx.gbl>
 <20141217101434.GA2155@newt.localdomain>
 <BN1PR06MB0702F0782A3A6B975EDA156D16D0@BN1PR06MB070.namprd06.prod.outlook.com>
 <20141217121719.GA7134@hudson.localdomain>
 <BAY176-W39AFAEB1037657BD495F30BD6D0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY176-W39AFAEB1037657BD495F30BD6D0@phx.gbl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dudley,

On Wed, Dec 17, 2014 at 01:53:38PM +0000, DuDudley wrote:
> 
> 
> > Date: Wed, 17 Dec 2014 04:17:19 -0800
> > From: jmmahler@gmail.com
> > To: dudl@cypress.com
> > CC: dudlx@outlook.com; dmitry.torokhov@gmail.com; rydberg@euromail.se; bleung@google.com; linux-input@vger.kernel.org; linux-kernel@vger.kernel.org; dso@cypress.com
> > Subject: Re: [PATCH v16 01/12] input: cyapa: re-design driver to support
> > 
> > Dudley,
> > 
> > On Wed, Dec 17, 2014 at 10:55:00AM +0000, Dudley Du wrote:
> > > Jeremiah,
> > > 
> > > Thanks for the feedback.
> > > Yes, the our net proxy may broken this. It needs sometime to fix this.
> > > 
> > > Attched are the patch files, could you try to apply these patch files firstly.
> > > 
> > > Thanks,
> > > Dudley
> > > 
> > 
> > Attachments are difficult to comment on [1].  Just re-send the series
> > when you can format them properly.
> Sorry, I cannot fix it today. I need IT help to try to fix this tommorrow.

That is fine.  What do you normally use to send your patches?  I use
git send-email after creating a series with git format-patch and it has
always worked well.

> > 
> >   [1]: linux/Documentation/SubmittingPatches
> > 
> > [...]
> > 
> > -- 
> > - Jeremiah Mahler
>  		 	   		  

-- 
- Jeremiah Mahler
