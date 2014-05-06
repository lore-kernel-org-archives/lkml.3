Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbaEFUHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:07:52 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:63536 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaEFUHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:07:51 -0400
Date: Tue, 6 May 2014 22:07:38 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: josh@joshtriplett.org, David Miller <davem@davemloft.net>,
        andi@firstfloor.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom.zanussi@linux.intel.com
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
Message-ID: <20140506200738.GA17813@netboy>
References: <20140506032114.GP2382@two.firstfloor.org>
 <20140505.232327.578134514220748085.davem@davemloft.net>
 <20140506155703.GA20391@cloud>
 <20140506.115941.428706504757835279.davem@davemloft.net>
 <20140506164108.GA20536@cloud>
 <20140506191447.GB4137@netboy>
 <20140506195049.GO19657@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140506195049.GO19657@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 12:50:49PM -0700, Andi Kleen wrote:
> 
> > So I think Dave is right
> > in rejecting anything that compromises the _quality_ of the stack.
> 
> I don't think anything I removed compromised quality (modulo bugs)
> It's still a more-features-than-your-typical-BSD TCP/IP stack

But Dave seems to think so.

My (obvious?) point is, if you make the stack different, and not just
smaller by omitting optional features, then that defeats the point of
wanting the Linux stack in the first place.

Thanks,
Richard
