Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaJALg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 07:36:26 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:38039 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaJALgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 07:36:24 -0400
Message-ID: <1412163388.26751.39.camel@iivanov-dev>
Subject: Re: [PATCH v2] thermal: Add QPNP PMIC temperature alarm driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Kiran Padwal <kiran.padwal@smartplayin.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, David Collins <collinsd@codeaurora.org>
Date: Wed, 01 Oct 2014 14:36:28 +0300
In-Reply-To: <542B088A.1050601@codeaurora.org>
References: <1411651825-14240-1-git-send-email-iivanov@mm-sol.com>
		  <54254C4E.3070807@smartplayin.com> <1411998865.5395.5.camel@iivanov-dev>
		 <542A31DF.7020402@smartplayin.com> <1412062606.5395.10.camel@iivanov-dev>
	 <542B088A.1050601@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-30 at 12:46 -0700, Stephen Boyd wrote:
> On 09/30/14 00:36, Ivan T. Ivanov wrote:
> > On Tue, 2014-09-30 at 10:00 +0530, Kiran Padwal wrote:
> >>
> >> I have Linaro cross tool chain with version-4.8.3 and I am simply doing "make zImage" without any option.
> > Hm, no warnings with arm-unknown-linux-gnueabi-gcc (GCC) 4.6.3 and
> > arm-linux-gnueabihf-gcc (crosstool-NG linaro-1.13.1-4.9-2014.09, but
> > indeed arm-linux-gnueabihf-gcc (crosstool-NG linaro-1.13.1-4.8-2014.03.
> >
> > I will say that this is false positive :-). Please update your tool-chain.
> 
> Hopefully you're joking. Once this merges someone will find the warning
> and complain. Telling them to upgrade their compiler isn't going to work.

If it is known to be buggy why not?

> 
> I wonder if checking for rc != 0 instead of rc < 0 would silence the
> warning? 

No. Anyway, will find some way to silence this warning.

Thanks,
Ivan

