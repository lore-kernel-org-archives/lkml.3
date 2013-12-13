Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab3LMCrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:47:48 -0500
Received: from ozlabs.org ([203.10.76.45]:35193 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab3LMCrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:47:47 -0500
Message-ID: <1386902862.3853.0.camel@concordia>
Subject: Re: [PATCH V4 08/10] powerpc, perf: Enable SW filtering in branch
 stack sampling framework
From: Michael Ellerman <mpe@ellerman.id.au>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: mikey@neuling.org, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        eranian@google.com, linuxppc-dev@ozlabs.org, acme@ghostprotocols.net,
        sukadev@linux.vnet.ibm.com, mingo@kernel.org
Date: Fri, 13 Dec 2013 13:47:42 +1100
In-Reply-To: <52A9779B.1030003@linux.vnet.ibm.com>
References: <20131209062146.EABBE2C00C1@ozlabs.org>
	 <52A6AD61.4050408@linux.vnet.ibm.com> <52A9779B.1030003@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-12 at 14:15 +0530, Anshuman Khandual wrote:
> On 12/10/2013 11:27 AM, Anshuman Khandual wrote:
> > On 12/09/2013 11:51 AM, Michael Ellerman wrote:
> >> This code was already in need of some unindentation, and now it's just
> >> ridiculous.
> >>
> >> To start with at the beginning of this routine we have:
> >>
> >> while (..) {
> >> 	if (!val)
> >> 		break;
> >> 	else {
> >> 		// Bulk of the logic
> >> 		...
> >> 	}
> >> }
> >>
> >> That should almost always become:
> >>
> >> while (..) {
> >> 	if (!val)
> >> 		break;
> >>
> >> 	// Bulk of the logic
> >> 	...
> >> }
> >>
> >>
> >> But in this case that's not enough. Please send a precursor patch which moves
> >> this logic out into a helper function.
> > 
> > Hey Michael,
> > 
> > I believe this patch should be able to take care of this.

...
 
> Does the patch looks okay ? In which case will send it out separately. Do let
> me know. Thank you.

It's OK.

Don't send it out separately, make it the first patch in your series.

cheers


