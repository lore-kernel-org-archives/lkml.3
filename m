Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbaE3Mu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 08:50:57 -0400
Received: from minas.ics.muni.cz ([147.251.4.46]:41761 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbaE3Muz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 08:50:55 -0400
Date: Fri, 30 May 2014 14:50:11 +0200
From: Jan Kasprzak <kas@fi.muni.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Xiangliang Yu <yuxiangl@marvell.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PATCH: mvsas: add support for Supermicro AOC-SAS2LP-MV8
Message-ID: <20140530125011.GN9638@fi.muni.cz>
References: <20140428145201.GG29712@fi.muni.cz>
 <F766E4F80769BD478052FB6533FA745D4F6368598F@SC-VEXCH4.marvell.com>
 <1398735385.2419.69.camel@dabdike.int.hansenpartnership.com>
 <F766E4F80769BD478052FB6533FA745D4F63685A27@SC-VEXCH4.marvell.com>
 <20140516120642.GW9638@fi.muni.cz>
 <20140528110815.GA19539@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528110815.GA19539@infradead.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Muni-Envelope-From: kas@fi.muni.cz
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (minas.ics.muni.cz [147.251.4.35]); Fri, 30 May 2014 14:50:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
: On Fri, May 16, 2014 at 02:06:42PM +0200, Jan Kasprzak wrote:
: > any news with this patch? Will it be acked by you and submitted upstream?
: > Thanks!
: 
: Give me an Acked-by and I'll pull it in.

Acked-By: Jan "Yenya" Kasprzak <kas@fi.muni.cz>

Not sure whether I should ack my own patch, though. But you may apply
it to the original one, which is identical to what I did.
http://marc.info/?l=linux-scsi&m=139277202005675&w=2

Thanks!

-Y.

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| New GPG 4096R/A45477D5 - see http://www.fi.muni.cz/~kas/pgp-rollover.txt |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
  There's clearly a balance between "octopus merges are fine" and "Christ,
  that's not an octopus, that's a Cthulhu merge".         --Linus Torvalds
