Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163AbaE1O0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 10:26:54 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33189 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754592AbaE1O0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 10:26:51 -0400
Message-ID: <1401287204.2288.28.camel@dabdike>
Subject: Re: [PATCH] acornscsi: remove linked command support
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Paul Bolle <pebolle@tiscali.nl>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 28 May 2014 18:26:44 +0400
In-Reply-To: <20140528104114.GE13542@infradead.org>
References: <1400926433.31526.89.camel@x220>
	 <20140528104114.GE13542@infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-28 at 03:41 -0700, Christoph Hellwig wrote:
> On Sat, May 24, 2014 at 12:13:53PM +0200, Paul Bolle wrote:
> > The acornscsi driver was added in v2.1.88. It has always #undef-ed
> > CONFIG_SCSI_ACORNSCSI_LINK near the top of acornscsi.c. And, just to be
> > sure, it has also always triggered a preprocessor error if
> > CONFIG_SCSI_ACORNSCSI_LINK was still defined. But, as far as I can see,
> > it has never even been possible to set SCSI_ACORNSCSI_LINK through
> > kconfig, or its predecessors, in the first place.
> > 
> > Let's remove the code involved.
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> And I have to disagree with James here, removing code that isn't even
> compiled always is an improvement, especially for an unmaintained
> driver.

Well, as I said, this is in theory a maintained driver, so just get an
ack from Russell and this debate is moot.

James


