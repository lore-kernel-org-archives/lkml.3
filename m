Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab3LDJIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:08:46 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:48084 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab3LDJIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:08:39 -0500
Message-ID: <1386148027.16040.14.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH 3/4] usb: chipidea: msm: Initialize offset of the
 capability registers
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Peter Chen <peter.chen@freescale.com>
Cc: alexander.shishkin@linux.intel.com, gregkh@linuxfoundation.org,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        davidb@codeaurora.org, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 04 Dec 2013 11:07:07 +0200
In-Reply-To: <20131204054341.GC29552@shlinux1.ap.freescale.net>
References: <1384176937-1658-1-git-send-email-iivanov@mm-sol.com>
	 <1384176937-1658-4-git-send-email-iivanov@mm-sol.com>
	 <20131204054341.GC29552@shlinux1.ap.freescale.net>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-04 at 13:43 +0800, Peter Chen wrote: 
> On Mon, Nov 11, 2013 at 03:35:36PM +0200, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> 
> The commit log is needed.


Will fix it.

Regards,
Ivan

> 
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > ---
> >  drivers/usb/chipidea/ci_hdrc_msm.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/usb/chipidea/ci_hdrc_msm.c b/drivers/usb/chipidea/ci_hdrc_msm.c
> > index 747d6c1..e9624f3 100644
> > --- a/drivers/usb/chipidea/ci_hdrc_msm.c
> > +++ b/drivers/usb/chipidea/ci_hdrc_msm.c
> > @@ -47,6 +47,7 @@ static void ci_hdrc_msm_notify_event(struct ci_hdrc *ci, unsigned event)
> >  
> >  static struct ci_hdrc_platform_data ci_hdrc_msm_platdata = {
> >  	.name			= "ci_hdrc_msm",
> > +	.capoffset		= DEF_CAPOFFSET,
> >  	.flags			= CI_HDRC_REGS_SHARED |
> >  				  CI_HDRC_REQUIRE_TRANSCEIVER |
> >  				  CI_HDRC_DISABLE_STREAMING,
> > -- 
> > 1.7.9.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 


