Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaBRRQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:16:20 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:52160 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593AbaBRRQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:16:15 -0500
Message-ID: <1392743694.17130.18.camel@iivanov-dev>
Subject: Re: [PATCH v2 2/3] usb: chipidea: msm: Add device tree support
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Peter Chen <Peter.Chen@freescale.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Tue, 18 Feb 2014 19:14:54 +0200
In-Reply-To: <20140218140854.GC31116@joshc.qualcomm.com>
References: <1392729681-21022-1-git-send-email-iivanov@mm-sol.com>
	 <1392729681-21022-3-git-send-email-iivanov@mm-sol.com>
	 <20140218140854.GC31116@joshc.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-18 at 08:08 -0600, Josh Cartwright wrote: 
> Hey Ivan-
> 
> Nit below.
> 
> On Tue, Feb 18, 2014 at 03:21:20PM +0200, Ivan T. Ivanov wrote:

> >  
> > +static struct of_device_id msm_ci_dt_match[] = {
> 
> const?
> 

Thanks, will do.

Regards,
Ivan

> > +	{ .compatible = "qcom,ci-hdrc", },
> > +	{ }
> > +};
> > +MODULE_DEVICE_TABLE(of, msm_ci_dt_match);
> 


