Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbaCKPBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 11:01:35 -0400
Received: from [172.245.23.124] ([172.245.23.124]:49213 "EHLO
	w1-ca.frizzlehost.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaCKPBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 11:01:34 -0400
From: Fred Akers <knivey@botops.net>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: gregkh@linuxfoundation.org, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: apci_1564: Fix long CamelCase function names
Date: Tue, 11 Mar 2014 11:01 -0400
Message-ID: <2413657.D5tXqSSMNL@zefy>
User-Agent: KMail/4.12.2 (Linux/3.12.0-sabayon; KDE/4.12.2; x86_64; ; )
In-Reply-To: <531F1E2B.3040300@mev.co.uk>
References: <1394350009-23464-1-git-send-email-knivey@botops.net> <531F1E2B.3040300@mev.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 11, 2014 02:31:07 PM Ian Abbott wrote:
> On 2014-03-09 07:26, Fred Akers wrote:
> > This patch fixes a few function names that are very long and are
> > not in the correct naming style
> > 
> > Signed-off-by: Fred Akers <knivey@botops.net>
> > ---
> > 
> >   .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 62
> >   ++++++++++------------ drivers/staging/comedi/drivers/addi_apci_1564.c 
> >     | 16 +++---
> >   2 files changed, 36 insertions(+), 42 deletions(-)
> > 
> > diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> > b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c index
> > a31e115..cb426e7 100644
> > --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> > +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> > @@ -116,7 +116,7 @@ static unsigned int ui_InterruptData, ui_Type;
> > 
> >   /*
> >   +-----------------------------------------------------------------------
> >   -----+> 
> > -| Function   Name   : int i_APCI1564_ConfigDigitalInput                  
> >    | +| Function   Name   : int i_apci1564_di_config                     
> > |
> It would be nice to get rid of the silly i_, v_ prefixes as well!

I'll submit a V2 removing those prefixes. I'm working on doing similar renames 
on functions for the other files under the addi-data directory as well. I'll 
include those in the V2 patch.
