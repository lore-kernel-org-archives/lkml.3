Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab3CYJcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 05:32:06 -0400
Received: from one.firstfloor.org ([193.170.194.197]:48584 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126Ab3CYJcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 05:32:04 -0400
Date: Mon, 25 Mar 2013 10:32:01 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Michael Neuling <mikey@neuling.org>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, x86@kernel.org
Subject: Re: [PATCH 02/29] x86, tsx: Add RTM intrinsics
Message-ID: <20130325093201.GO20853@two.firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
 <1364001923-10796-3-git-send-email-andi@firstfloor.org>
 <30471.1364182834@ale.ozlabs.ibm.com>
 <20130325081556.GS19692@tassilo.jf.intel.com>
 <15400.1364201661@ale.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15400.1364201661@ale.ozlabs.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Well x and tm doesn't really matter, but I already have x* so i'm inclined
> > to keep it, unless people bikeshed too strongly. It should work for PPC too.
> 
> Well if you're moving it out of generic code then it doesn't really
> matter anymore.  

The only operations I want generic is _xtest() and _xabort()
None of them will be very widely used, but they are useful for various
tunings.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
