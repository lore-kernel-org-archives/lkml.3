Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbaF1CaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 22:30:18 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:60156 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbaF1CaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 22:30:16 -0400
Date: Sat, 28 Jun 2014 04:30:09 +0200
From: Guillaume Morin <guillaume@morinfr.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guillaume Morin <guillaume@morinfr.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] staging: iio: ad9850.c: fix checkpatch.pl error
Message-ID: <20140628023009.GA13273@bender.morinfr.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Guillaume Morin <guillaume@morinfr.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Sachin Kamat <sachin.kamat@linaro.org>, linux-iio@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <4d0e6b74dcc10ef5d60c9cab4f2df886782fb3c3.1403919775.git.guillaume@morinfr.org>
 <20140628020935.GA14333@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140628020935.GA14333@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 Jun 19:09, Greg Kroah-Hartman wrote:
> > v2: add missing Signed-off-by 
> 
> That doesn't go here.

I guess I am struggling to get git send-email do what I want

> And what checkpatch error did you fix?  And are you sure it needs to be
> fixed?

That's what I changed:

$ scripts/checkpatch.pl -f drivers/staging/iio/frequency/ad9850.c
ERROR: Macros with complex values should be enclosed in parenthesis
#24: FILE: drivers/staging/iio/frequency/ad9850.c:24:
+#define value_mask (u16)0xf000

I assumed that if it was reported as an error, it needed to be fixed...

-- 
Guillaume Morin <guillaume@morinfr.org>
