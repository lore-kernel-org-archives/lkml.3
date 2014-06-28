Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbaF1DKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 23:10:51 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:19167 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbaF1DKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 23:10:50 -0400
Date: Sat, 28 Jun 2014 05:10:46 +0200
From: Guillaume Morin <guillaume@morinfr.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guillaume Morin <guillaume@morinfr.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] staging: iio: ad9850.c: fix checkpatch.pl error
Message-ID: <20140628031045.GA13985@bender.morinfr.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Guillaume Morin <guillaume@morinfr.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Sachin Kamat <sachin.kamat@linaro.org>, linux-iio@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <4d0e6b74dcc10ef5d60c9cab4f2df886782fb3c3.1403919775.git.guillaume@morinfr.org>
 <20140628020935.GA14333@kroah.com>
 <20140628023009.GA13273@bender.morinfr.org>
 <20140628023718.GB3579@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140628023718.GB3579@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 Jun 22:37, Greg Kroah-Hartman wrote:
> Put that below the --- line.

Will do.

> > > And what checkpatch error did you fix?  And are you sure it needs to be
> > > fixed?
> > 
> > That's what I changed:
> > 
> > $ scripts/checkpatch.pl -f drivers/staging/iio/frequency/ad9850.c
> > ERROR: Macros with complex values should be enclosed in parenthesis
> 
> Then why didn't you say that :)

Well it was not totally clear to me if that was obvious or not.  Anyway,
I'll mention it in the future.

> 
> > I assumed that if it was reported as an error, it needed to be fixed...
> 
> Use your judgement, checkpatch is a tool, it isn't always correct.

Right, I guess it's borderline.  Should I resend the patch or just drop
it?

Guillaume.

-- 
Guillaume Morin <guillaume@morinfr.org>
