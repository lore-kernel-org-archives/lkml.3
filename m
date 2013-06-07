Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab3FGPBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:01:09 -0400
Received: from 1wt.eu ([62.212.114.60]:36156 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584Ab3FGPBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:01:07 -0400
Date: Fri, 7 Jun 2013 17:00:57 +0200
From: Willy Tarreau <w@1wt.eu>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Timo =?iso-8859-1?Q?Ter=E4s?= <timo.teras@iki.fi>
Subject: Re: [ 150/184] ipv4: check rt_genid in dst_check
Message-ID: <20130607150057.GF19006@1wt.eu>
References: <20130604172136.519104713@1wt.eu> <1370585253.4021.93.camel@deadeye.wl.decadent.org.uk> <20130607145806.GR15183@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130607145806.GR15183@kvack.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 10:58:06AM -0400, Benjamin LaHaise wrote:
> On Fri, Jun 07, 2013 at 07:07:33AM +0100, Ben Hutchings wrote:
> > > This commit is based on the above, with the addition of verifying blackhole
> > > routes in the same manner.
> > 
> > That addition doesn't seem to correspond to anything in mainline.  Why
> > should 2.6.32 differ?
> 
> Fixing the issue with blackhole routes as it was accomplished in mainline 
> would require pulling in a lot more code, and people were not interested 
> in pulling in all of the dependencies given the much higher risk of trying 
> to select the right subset of changes to include.  The addition of the 
> single line of "dst->obsolete = -1;" in ipv4_dst_blackhole() was much 
> easier to verify, and is in the spirit of the patch in question.  This is 
> the minimal set of changes to fix the bug in question.

Thank you Ben, I'll add this description to the existing commit message.

Best regards,
Willy

