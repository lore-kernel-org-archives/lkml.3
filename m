Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab3A0AW7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 19:22:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:16562 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852Ab3A0AW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 19:22:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,545,1355126400"; 
   d="scan'208";a="282617477"
Date: Sun, 27 Jan 2013 01:22:51 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mfd: wm8994: Use devm_regulator_bulk_get API
Message-ID: <20130127002251.GE1174@sortiz-mobl>
References: <1357633882-5191-1-git-send-email-sachin.kamat@linaro.org>
 <20130108103653.GH4544@opensource.wolfsonmicro.com>
 <CAK9yfHzgnH3z57=yjHPeURP7=SU5oYPoyM3meeV=h295T+ZW3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK9yfHzgnH3z57=yjHPeURP7=SU5oYPoyM3meeV=h295T+ZW3Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

On Thu, Jan 24, 2013 at 09:13:20AM +0530, Sachin Kamat wrote:
> Hi Samuel,
> 
> On 8 January 2013 16:06, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> > On Tue, Jan 08, 2013 at 02:01:22PM +0530, Sachin Kamat wrote:
> >> devm_regulator_bulk_get is device managed and saves some cleanup
> >> and exit code.
> >
> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> Would you be picking this patch up?
I will, yes.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
