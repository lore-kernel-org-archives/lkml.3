Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbaLPSXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 13:23:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:43804 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbaLPSXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 13:23:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,588,1413270000"; 
   d="scan'208";a="648595120"
Date: Tue, 16 Dec 2014 09:41:37 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PM <linux-pm@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: Re: [PATCH 1/2] powercap/rapl: add ids for future xeon cpus
Message-ID: <20141216094137.516ab5d2@ultegra>
In-Reply-To: <20141216003648.GA32627@roeck-us.net>
References: <1418667255-8804-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<20141216003648.GA32627@roeck-us.net>
Organization: OTC
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Dec 2014 16:36:48 -0800
Guenter Roeck <linux@roeck-us.net> wrote:

> On Mon, Dec 15, 2014 at 10:14:15AM -0800, Jacob Pan wrote:
> > Enable RAPL driver on Xeon cpu id 0x56.
> > 
> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > ---
> >  drivers/powercap/intel_rapl.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/powercap/intel_rapl.c
> > b/drivers/powercap/intel_rapl.c index c71443c..ee00ffb 100644
> > --- a/drivers/powercap/intel_rapl.c
> > +++ b/drivers/powercap/intel_rapl.c
> > @@ -1041,6 +1041,7 @@ static const struct x86_cpu_id rapl_ids[] = {
> >  	RAPL_CPU(0x45, rapl_defaults_core),/* Haswell ULT */
> >  	RAPL_CPU(0x4C, rapl_defaults_atom),/* Braswell */
> >  	RAPL_CPU(0x4A, rapl_defaults_atom),/* Tangier */
> > +	RAPL_CPU(0x56, rapl_defaults_atom),/* Future Xeon */
> 
> Is rapl_defaults_atom correct, or should this be rapl_defaults_core ?
> 
you are right should be core, will fix.

thanks
> Guenter
> 
> >  	RAPL_CPU(0x5A, rapl_defaults_atom),/* Annidale */
> >  	{}
> >  };
> > -- 
> > 1.9.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> > 

[Jacob Pan]
