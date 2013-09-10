Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab3IJWTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:19:41 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:15602 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab3IJWTk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:19:40 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LKML-scsi <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 1/4] hpsa: add HP Smart Array Gen9 PCI ID's
Thread-Topic: [PATCH 1/4] hpsa: add HP Smart Array Gen9 PCI ID's
Thread-Index: AQHOrnFl8irb+a7FpUCvtfnv3JrMIJm/iH+Q
Date: Tue, 10 Sep 2013 22:17:33 +0000
Message-ID: <48275AD710FCA34184C2B6186B4016B32D0FCEED@G6W2491.americas.hpqcorp.net>
References: <20130904200555.GA28147@beardog.cce.hp.com>
 <1378850521.23501.47.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1378850521.23501.47.camel@dabdike.int.hansenpartnership.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.193.49.23]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Tuesday, September 10, 2013 5:02 PM
To: Miller, Mike (OS Dev)
Cc: Andrew Morton; LKML; LKML-scsi
Subject: Re: [PATCH 1/4] hpsa: add HP Smart Array Gen9 PCI ID's

On Wed, 2013-09-04 at 15:05 -0500, Mike Miller wrote:
> Patch 1 of 4
> 
> From: Mike Miller <mike.miller@hp.com>

Just for future reference, doing it this way means I have to edit the patch.  The way git am works when applying patches is that if the first body line is a keyword it recognises (like From: or Subject: or Date:) it will fold that into the commit metadata, otherwise everything becomes the commit message.  So by putting the redundant "patch 1 of 4" first, git thinks the entire body is the commit message.

James

Sorry about that. I didn't realize git worked that way. So let me ask a dumb question, just having [PATCH x/y] in the subject line is enough? Would you like me to resubmit the patchset?

-- mikem

> This patch adds the PCI ID's for HP Smart Array Gen9 controllers. 
> Please consider this patch for inclusion.
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>
> ---


