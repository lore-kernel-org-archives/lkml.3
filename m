Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbaGOBqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 21:46:55 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:51096 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbaGOBqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 21:46:53 -0400
Date: Mon, 14 Jul 2014 18:46:49 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Dinh Nguyen <dinguyen@altera.com>
Cc: Graham Moore <grmoore@altera.com>, ggrahammoore@gmail.com,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Alan Tull <atull@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Subject: Re: [PATCH V2] In the Denali NAND controller driver, use 8 bytes for
 READID command.
Message-ID: <20140715014649.GT7537@ld-irv-0074>
References: <1403551270-31873-1-git-send-email-grmoore@altera.com>
 <1403553015.9081.7.camel@linux-builds1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403553015.9081.7.camel@linux-builds1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 02:50:15PM -0500, Dinh Nguyen wrote:
> On Mon, 2014-06-23 at 14:21 -0500, Graham Moore wrote:
> > The Denali NAND driver reads only 5 bytes of ID, but some Hynix and Samsung
> > have size parameters in the 6th byte.  As a result, the page and oob size
> > for a Hynix H27UAG8T2B were calculated incorrectly and the driver failed to
> > load.
> > 
> > The solution is to read 8 bytes of ID, as expected by the nand framework.
> > 
> > Signed-off-by: Graham Moore <grmoore@altera.com>
> > --
> > V2: Increase size of id_bytes array to 8.
> > ---
> >  drivers/mtd/nand/denali.c |    6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Your commit header should have "mtd: denali:"
> 
> i.e: "mtd: denali: use 8 bytes for READID command"

Modified the subject and pushed to l2-mtd.git. Thanks!

Brian
