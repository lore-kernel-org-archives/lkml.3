Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbbARAPv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 19:15:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56282 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbbARAPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 19:15:49 -0500
Date: Sat, 17 Jan 2015 16:06:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Mohammad Jamal <md.jamalmohiuddin@gmail.com>,
        laurent.pinchart@ideasonboard.com, devendra.aaru@gmail.com,
        athirasnamby@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: clocking-wizard: Added a blank line after
 declaration
Message-ID: <20150118000604.GA9798@kroah.com>
References: <1419129228-5333-1-git-send-email-md.jamalmohiuddin@gmail.com>
 <b95962feaec54d2495d57d038af04ad0@BN1BFFO11FD016.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b95962feaec54d2495d57d038af04ad0@BN1BFFO11FD016.protection.gbl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2014 at 10:11:56PM -0800, Sören Brinkmann wrote:
> Hi Mohammad,
> 
> On Sun, 2014-12-21 at 08:03AM +0530, Mohammad Jamal wrote:
> > Fix the coding style issue by adding blank line after declaration
> > 
> > Signed-off-by: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
> > ---
> >  .../clocking-wizard/clk-xlnx-clock-wizard.c        |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c b/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
> > index 471d087..ea8d561 100644
> > --- a/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
> > +++ b/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
> > @@ -239,6 +239,7 @@ static int clk_wzrd_probe(struct platform_device *pdev)
> >  	/* register div per output */
> >  	for (i = WZRD_NUM_OUTPUTS - 1; i >= 0 ; i--) {
> >  		const char *clkout_name;
> > +
> >  		if (of_property_read_string_index(np, "clock-output-names", i,
> >  						  &clkout_name)) {
> >  			dev_err(&pdev->dev,
> 
> I think the same patch had already been sent to the list by somebody
> else. Not sure whether Greg picked it up yet.
> Either way, feel free to add my
> Acked-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

I now have, so this one will not apply :(
