Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaKDPRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:17:41 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:45715 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbaKDPRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:17:39 -0500
Message-ID: <1415114256.29957.12.camel@mm-sol.com>
Subject: Re: [PATCH] mfd: qcom-spmi-pmic: Add support for more chips versions
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Date: Tue, 04 Nov 2014 17:17:36 +0200
In-Reply-To: <CAOMZO5Bkmqmm6Fe-iKHbnZS=1f3TQKQ0E4+XMOk1XqCaEeuW_g@mail.gmail.com>
References: <1415108003-16387-1-git-send-email-iivanov@mm-sol.com>
	 <CAOMZO5Bkmqmm6Fe-iKHbnZS=1f3TQKQ0E4+XMOk1XqCaEeuW_g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.6-fta3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2014-11-04 at 12:56 -0200, Fabio Estevam wrote:
> On Tue, Nov 4, 2014 at 11:33 AM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
> 
> > +       ret = regmap_read(map, PMIC_SUBTYPE, &subtype);
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       rev2 = regmap_read(map, PMIC_REV2, &rev2);
> > +       if (ret < 0)
> > +               return ret;
> 
> I think you meant:
> ret = regmap_read(map, PMIC_REV2, &rev2);
> 
> > +
> > +       rev3 = regmap_read(map, PMIC_REV3, &rev3);
> 
> Likewise.
> 
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       rev4 = regmap_read(map, PMIC_REV4, &rev4);
> 
> Likewise.
> 
> > 


True. Will fix.

Thank you.
Ivan
