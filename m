Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbaHUJXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 05:23:12 -0400
Received: from 80-229-23-162.plus.com ([80.229.23.162]:48421 "EHLO
	mail.einon.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbaHUJXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 05:23:10 -0400
Date: Thu, 21 Aug 2014 10:23:05 +0100
From: Mark Einon <mark.einon@gmail.com>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 8/8] staging: et131x: Implement NAPI support
Message-ID: <20140821092302.GB2230@msilap.einon.net>
References: <1408573078-9320-1-git-send-email-mark.einon@gmail.com>
 <1408573078-9320-9-git-send-email-mark.einon@gmail.com>
 <20140820202501.558fdb3f@uryu.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820202501.558fdb3f@uryu.home.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 08:25:01PM -0700, Stephen Hemminger wrote:
> On Wed, 20 Aug 2014 23:17:58 +0100
> Mark Einon <mark.einon@gmail.com> wrote:
> 
> >  
> > +	if (budget > MAX_PACKETS_HANDLED)
> > +		limit = MAX_PACKETS_HANDLED;
> 
> Why this artificial restriction?

Hi Stephen, thanks for the review.

It's a restriction that was in the original driver code, and I'm being
cautious. I don't have much documentation for the device, and I haven't
yet figured a way to test the limit so I can play with removing it. If
you have any suggestions on how to do that, I'd be happy to hear them.

Cheers,

Mark
