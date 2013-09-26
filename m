Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab3IZFEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 01:04:14 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:38470 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab3IZFEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 01:04:12 -0400
Subject: Re: [PATCH 1/2] i2c: qup: Add device tree bindings information
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Josh Cartwright <joshc@codeaurora.org>, Kumar Gala <galak@codeaurora.org>,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        grant.likely@linaro.org, gavidov@codeaurora.org,
        sdharia@codeaurora.org, alokc@codeaurora.org,
        linux-i2c@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
In-Reply-To: <20130925160606.GA3377@katana>
References: <1377782873-31931-1-git-send-email-iivanov@mm-sol.com>
	 <3A0F4153-1C55-4008-8EB1-D6FA60D87CEA@codeaurora.org>
	 <1377797186.30358.14.camel@localhost>
	 <767E9FBB-2975-4795-9C7E-69E302511FF2@codeaurora.org>
	 <1378814937.960.37.camel@iivanov-dev.int.mm-sol.com>
	 <20130910135907.GP808@joshc.qualcomm.com>
	 <1378824205.960.41.camel@iivanov-dev.int.mm-sol.com>
	 <20130925160606.GA3377@katana>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Sep 2013 08:04:09 +0300
Message-ID: <1380171849.4671.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wed, 2013-09-25 at 18:06 +0200, Wolfram Sang wrote:
> > > I agree with Kumar on removing this.  If we decide it is something worth
> > > keeping, logic to support it doesn't belong in the QUP driver, but in
> > > the i2c core.
> > 
> > I don't have strong objection here, will remove aliases support.
> 
> When resubmitting, please test against v3.12-rcX.
> of_i2c_register_devices() is in the core meanwhile and alias support for
> of is in the core for a while, too. Check i2c_add_adapter().

Thanks, I will.

Regards,
Ivan


