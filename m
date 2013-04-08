Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935121Ab3DHJVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:21:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:1119 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934384Ab3DHJVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:21:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,429,1363158000"; 
   d="scan'208";a="224423313"
Date: Mon, 8 Apr 2013 11:21:07 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] mfd: adp5520: Use module_i2c_driver()
Message-ID: <20130408092107.GJ24058@zurbaran>
References: <1363347628-15344-1-git-send-email-sachin.kamat@linaro.org>
 <CAK9yfHyw+rfgpBW+JiGE4bgv3s5t3nmGxoeqzE-ystq_b+mf8A@mail.gmail.com>
 <544AC56F16B56944AEC3BD4E3D591771602C593BF8@LIMKCMBX1.ad.analog.com>
 <CAK9yfHzcRED3jiVRfkMpEPzKmYyS7dw+Lx+vOekG4o4nbc_KUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK9yfHzcRED3jiVRfkMpEPzKmYyS7dw+Lx+vOekG4o4nbc_KUw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 02:05:37PM +0530, Sachin Kamat wrote:
> On 27 March 2013 14:50, Hennerich, Michael <Michael.Hennerich@analog.com> wrote:
> >
> > ________________________________________
> > Von: Sachin Kamat [sachin.kamat@linaro.org]
> > Gesendet: Mittwoch, 27. März 2013 09:59
> > An: device-drivers-devel@blackfin.uclinux.org; LKML
> > Cc: Hennerich, Michael; sameo@linux.intel.com; sachin.kamat@linaro.org
> > Betreff: Re: [PATCH 1/1] mfd: adp5520: Use module_i2c_driver()
> >
> > On 15 March 2013 17:10, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> >> module_i2c_driver() removes some boilerplate and makes the code
> >> simple.
> >>
> >> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> >
> > Acked-by: Michael Hennerich <michael.hennerich@analog.com>
> >
> 
> Ping Samuel.
Patch applied to mfd-next, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
