Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaCaJte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 05:49:34 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49231 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbaCaJtb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 05:49:31 -0400
Date: Mon, 31 Mar 2014 10:49:28 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Ryan <ryan@desfo.org>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pci: changed '...pci_bus* bus' to '...pci_bus *bus'
Message-ID: <20140331094928.GD17163@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Ryan <ryan@desfo.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1396034018-5645-1-git-send-email-ryan@desfo.org>
 <533885B0.5010001@desfo.org>
MIME-Version: 1.0
In-Reply-To: <533885B0.5010001@desfo.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 31 Mar 2014 09:49:45.0434 (UTC) FILETIME=[8C133BA0:01CF4CC6]
X-MC-Unique: 114033110492911701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2014 at 09:59:28PM +0100, Ryan wrote:
> Hello,
> 
> This is my first patch.  I'm looking for feedback pertaining to my
> submission that way I can submit more patches correctly in the future. 
> Any constructive feedback is welcome.

Documentation/SubmittingPatches is always a good source of good practices.

> 
> I have one question in particular regarding the 'Sign by' section in the
> git commit message.  Am I suppose to add a 'Sign by' line for myself or
> is that for the core kernel team?

You can find Section 12 of the file mentioned above relevant. Signed-off-by
is a way of telling others that you have the right to release the code that
you are posting *and* (IMHO) will take responsability for the modifications you
make (i.e. if someone will complain about things breaking up you will fix them).

Best regards,
Liviu

> 
> Thank you for time and feedback,
> Ryan
> 
> On 03/28/2014 03:13 PM, Ryan Desfosses wrote:
> >    change made to resolve following checkpatch message:
> >        drivers/pci/pci.c:109: ERROR: "foo* bar" should be "foo *bar"
> > ---
> >  drivers/pci/pci.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > index fdbc294..a50d542 100644
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -106,7 +106,7 @@ static bool pcie_ari_disabled;
> >   * Given a PCI bus, returns the highest PCI bus number present in the set
> >   * including the given PCI bus and its list of child PCI buses.
> >   */
> > -unsigned char pci_bus_max_busnr(struct pci_bus* bus)
> > +unsigned char pci_bus_max_busnr(struct pci_bus *bus)
> >  {
> >  	struct list_head *tmp;
> >  	unsigned char max, n;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

