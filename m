Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbaJCOc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 10:32:29 -0400
Received: from mga14.intel.com ([192.55.52.115]:47274 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498AbaJCOc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 10:32:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,647,1406617200"; 
   d="scan'208";a="481756693"
Message-ID: <1412346717.2987.5.camel@spandruv-hsb-test>
Subject: Re: [PATCH] iio: inkern: Add of_xlate function to struct iio_dev
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Jonathan Cameron <jic23@kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        John Stultz <john.stultz@linaro.org>, linux-iio@vger.kernel.org,
        svarbanov@mm-sol.com, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Fri, 03 Oct 2014 07:31:57 -0700
In-Reply-To: <1412257785.1027.40.camel@iivanov-dev>
References: <1412253128-32165-1-git-send-email-iivanov@mm-sol.com>
	 <542D5377.90201@metafoo.de> <1412257785.1027.40.camel@iivanov-dev>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-02 at 16:49 +0300, Ivan T. Ivanov wrote:
> On Thu, 2014-10-02 at 15:30 +0200, Lars-Peter Clausen wrote:
> > On 10/02/2014 02:32 PM, Ivan T. Ivanov wrote:
> > > When #iio-cells is greater than '0', the driver could provide
> > > a custom of_xlate function that reads the *args* and returns
> > > the appropriate index in registered IIO channels array.
> > 
> > Do you have an example of a device that doesn't want to use the default 
> > mapping? If yes please include it in the commit message, otherwise it is 
> > fairly hard to say whether this makes sense or not.
> 
> Still not mainlined. You can find more detailed description of the 
> issue here[1] and driver here[2].
I see your need. I wonder this mapping be done in individual client
driver instead of creating another callback.

Thanks,
Srinivas

> 
> Regards,
> Ivan
> 
> [1] https://lkml.org/lkml/2014/10/2/123
> [2] http://www.spinics.net/lists/devicetree/msg50717.html
> 
> 


