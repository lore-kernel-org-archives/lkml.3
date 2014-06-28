Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbaF1Chc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 22:37:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48231 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaF1Cha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 22:37:30 -0400
Date: Fri, 27 Jun 2014 22:37:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guillaume Morin <guillaume@morinfr.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] staging: iio: ad9850.c: fix checkpatch.pl error
Message-ID: <20140628023718.GB3579@kroah.com>
References: <4d0e6b74dcc10ef5d60c9cab4f2df886782fb3c3.1403919775.git.guillaume@morinfr.org>
 <20140628020935.GA14333@kroah.com>
 <20140628023009.GA13273@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140628023009.GA13273@bender.morinfr.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2014 at 04:30:09AM +0200, Guillaume Morin wrote:
> On 27 Jun 19:09, Greg Kroah-Hartman wrote:
> > > v2: add missing Signed-off-by 
> > 
> > That doesn't go here.
> 
> I guess I am struggling to get git send-email do what I want

Put that below the --- line.

> > And what checkpatch error did you fix?  And are you sure it needs to be
> > fixed?
> 
> That's what I changed:
> 
> $ scripts/checkpatch.pl -f drivers/staging/iio/frequency/ad9850.c
> ERROR: Macros with complex values should be enclosed in parenthesis

Then why didn't you say that :)

> I assumed that if it was reported as an error, it needed to be fixed...

Use your judgement, checkpatch is a tool, it isn't always correct.

greg k-h
