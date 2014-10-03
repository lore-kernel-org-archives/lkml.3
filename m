Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbaJCSRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 14:17:46 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:53537 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbaJCSRn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 14:17:43 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Christoph Hellwig <hch@infradead.org>,
        Douglas Gilbert <dgilbert@interlog.com>
CC: SCSI development list <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: RE: [PATCH] scsi_debug: deadlock between completions and surprise
 module removal
Thread-Topic: [PATCH] scsi_debug: deadlock between completions and surprise
 module removal
Thread-Index: AQHPxXC6SimyL4UyC0aeWTPajWncPpwR6UuAgAzaCwA=
Date: Fri, 3 Oct 2014 18:16:26 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CCCE2C@G4W3202.americas.hpqcorp.net>
References: <5403AB47.3040706@interlog.com>
 <20140925121317.GA16303@infradead.org>
In-Reply-To: <20140925121317.GA16303@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Christoph Hellwig
> Sent: Thursday, 25 September, 2014 7:13 AM
> To: Douglas Gilbert
> Cc: SCSI development list; linux-kernel; James Bottomley; Christoph Hellwig;
> Milan Broz
> Subject: Re: [PATCH] scsi_debug: deadlock between completions and surprise
> module removal
> 
> Review ping again?
> 
> While I think the shutdown code in scsi_debug needs a bit more of an
> overhault I'd really like to include the fix at least for 3.18 and
> 3.17-stable now that we have missed the 3.17 window.
> 
> On Sun, Aug 31, 2014 at 07:09:59PM -0400, Douglas Gilbert wrote:
> > A deadlock has been reported when the completion
> > of SCSI commands (simulated by a timer) was surprised
> > by a module removal. This patch removes one half of
> > the offending locks around timer deletions. This fix
> > is applied both to stop_all_queued() which is were
> > the deadlock was discovered and stop_queued_cmnd()
> > which has very similar logic.
> >
> > This patch should be applied both to the lk 3.17 tree
> > and Christoph's drivers-for-3.18 tree.
> >
> > Tested-and-reported-by: Milan Broz <gmazyland@gmail.com>
> > Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

Reviewed-by: Robert Elliott <elliott@hp.com>



