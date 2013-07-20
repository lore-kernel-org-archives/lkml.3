Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab3GTMrk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 08:47:40 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:62984 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab3GTMri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 08:47:38 -0400
Date: Sat, 20 Jul 2013 13:47:33 +0100
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>, jic23@cam.ac.uk,
        gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net
Subject: Re: [PATCH 00/15] iio: ti_am335x_adc: Add continuous mode take 2
Message-ID: <20130720124731.GA10834@gmail.com>
References: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
 <51EA73BC.8050901@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EA73BC.8050901@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 20, 2013 at 12:25:48PM +0100, Jonathan Cameron wrote:
> I am a little irritated by the mess we have here.  Russ has clearly done
> a lot of fine work cleaning up the earlier patches.  As a result
> we have a series of initial buggy patches and then a series of patches
> fixing them again.

Indeed.

I had already merged a lot of minor bug fixes from Rachil into the main
patch that adds continuous mode.

But I kept Russ's ones separate because of authorship and history.
 

> Part 1.  Any fixes that are unconnected to the rest of the series.  These will
>   then get sent upstream within this cycle.

Understood. I'll send a small series that is disjoint and contains fixes for the existing driver.

> Part 2. Feature add patch. Here that is basically a single patch adding the
>   continous mode support.
>
> It is nice to maintain history and all but I would much rather have something
> that is easy to review, with appropriate comments or if people will give
> them, sign offs to reflect the various contributions.
> 
> Jonathan

And then one patch for continuous mode with appropriate comments/sign-offs.

Thank-you
Zubair Lutfullah
