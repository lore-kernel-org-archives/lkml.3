Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbaKCKua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:50:30 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:34024 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbaKCKu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:50:27 -0500
Message-ID: <1415011844.407.14.camel@mm-sol.com>
Subject: Re: [PATCH v2] iio: inkern: Add of_xlate function to struct iio_info
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Jonathan Cameron <jic23@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Hartmut Knaack <knaack.h@gmx.de>, Peter Meerwald <pmeerw@pmeerw.net>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Mon, 03 Nov 2014 12:50:44 +0200
In-Reply-To: <1415010975.3828.21.camel@spandruv-hsb-test>
References: <1413991783-24562-1-git-send-email-iivanov@mm-sol.com>
	 <5447CDFA.5030407@metafoo.de> <544B75B8.1010505@kernel.org>
	 <1415009224.407.13.camel@mm-sol.com>
	 <1415010975.3828.21.camel@spandruv-hsb-test>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.6-fta3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2014-11-03 at 02:36 -0800, Srinivas Pandruvada wrote:
> On Mon, 2014-11-03 at 12:07 +0200, Ivan T. Ivanov wrote:
> > On Sat, 2014-10-25 at 11:04 +0100, Jonathan Cameron wrote:
> > > On 22/10/14 16:32, Lars-Peter Clausen wrote:
> > > > On 10/22/2014 05:29 PM, Ivan T. Ivanov wrote:
> > > > > When #iio-cells is greater than '0', the driver could provide
> > > > > a custom of_xlate function that reads the *args* and returns
> > > > > the appropriate index in registered IIO channels array.
> > > > > 
> > > > > Add simple translation function, suitable for the most 1:1
> > > > > mapped channels in IIO chips, and use it when driver did not
> > > > > provide custom implementation.
> > > > > 
> > > > > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > > > 
> > > > Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
> > > > 
> > > Applied to the togreg branch of iio.git - initially pushed out as testing
> > > for the autobuilders to play with it.
> > 
> > Thank you. Probably my git skills failed me, but I can not
> > find it in aforementioned branches. Is it publicly pushed?
> > 
> check here
> https://www.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git
> checkout branch: remotes/origin/testing

Thank you.
Ivan
