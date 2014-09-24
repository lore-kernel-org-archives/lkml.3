Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaIXUbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:31:11 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:46118 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbaIXUbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:31:08 -0400
Message-ID: <1411590657.9536.1.camel@mm-sol.com>
Subject: Re: [PATCH RESEND] thermal: Add QPNP PMIC temperature alarm driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, David Collins <collinsd@codeaurora.org>
Date: Wed, 24 Sep 2014 23:30:57 +0300
In-Reply-To: <20140924182410.GD27076@developer>
References: <1410793383-30097-1-git-send-email-iivanov@mm-sol.com>
	 <20140915153052.GB27076@developer> <1411570570.18580.72.camel@iivanov-dev>
	 <20140924182410.GD27076@developer>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-24 at 14:24 -0400, Eduardo Valentin wrote:
> Hello Ivan,
> 
> On Wed, Sep 24, 2014 at 05:56:10PM +0300, Ivan T. Ivanov wrote:
> > On Mon, 2014-09-15 at 11:30 -0400, Eduardo Valentin wrote:
> > > Hey Ivan,
> > > 
> > > Please give us at least a two weeks time frame before resending your
> > > patches.
> > 
> > Hi Eduardo, 
> > 
> > Should I wait for more comments or I can post updated
> > version of this patch?
> > 
> 
> Please, if you have a new version, I would prefer you send it as V2. I
> am specially interested about the cooling parts of it, and the DT usage.

I really don't know what to say about cooling, there is no cooling.
It is supposed that system just shut down, in case of overheat, 
I believe.

Regards,
Ivan

