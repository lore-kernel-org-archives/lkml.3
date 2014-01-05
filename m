Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaAEX0o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 18:26:44 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58973 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751405AbaAEX0n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 18:26:43 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] drivers: pnp: Mark the function pnp_build_option() as static in resource.c
Date: Mon, 06 Jan 2014 00:40:27 +0100
Message-ID: <1843110.Iut30gBcrQ@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20131214205836.GU17601@leaf>
References: <20131214132056.GA8624@rashika> <20131214205836.GU17601@leaf>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 14, 2013 12:58:37 PM Josh Triplett wrote:
> On Sat, Dec 14, 2013 at 06:50:56PM +0530, Rashika Kheria wrote:
> > This patch marks the function pnp_build_option() as static in resource.c
> > because it is not used outside this file.
> > 
> > Thus, it also eliminates the following warning in resource.c:
> > drivers/pnp/resource.c:34:20: warning: no previous prototype for ‘pnp_build_option’ [-Wmissing-prototypes]
> > 
> > Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Queued up for 3.14, thanks!

> >  drivers/pnp/resource.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
> > index d95e101..bacddd1 100644
> > --- a/drivers/pnp/resource.c
> > +++ b/drivers/pnp/resource.c
> > @@ -31,7 +31,7 @@ static int pnp_reserve_mem[16] = {[0 ... 15] = -1 };	/* reserve (don't use) some
> >   * option registration
> >   */
> >  
> > -struct pnp_option *pnp_build_option(struct pnp_dev *dev, unsigned long type,
> > +static struct pnp_option *pnp_build_option(struct pnp_dev *dev, unsigned long type,
> >  				    unsigned int option_flags)
> >  {
> >  	struct pnp_option *option;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
