Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaHKHQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 03:16:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbaHKHQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 03:16:17 -0400
Date: Mon, 11 Aug 2014 12:45:27 +0530
From: Amit Shah <amit.shah@redhat.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: jgarzik@bitpay.com,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Amos Kong <akong@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>, duwe@lst.de
Subject: Re: [PATCH 1/2] rngd: add udev rule to source from hwrng if
 virtio-rng present
Message-ID: <20140811071527.GB4184@grmbl.mre>
References: <cover.1407416628.git.amit.shah@redhat.com>
 <dd2ddb8458e5ab5cffceb7fac2e3f71e9e2197f3.1407416628.git.amit.shah@redhat.com>
 <53E3D3FF.70707@linux.intel.com>
 <20140808090715.GG14400@grmbl.mre>
 <53E54533.8030109@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E54533.8030109@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Fri) 08 Aug 2014 [14:46:27], H. Peter Anvin wrote:
> On 08/08/2014 02:07 AM, Amit Shah wrote:
> >
> > 
> >>  To
> >> some degree the above is obsolete when we get khwrngd widely deployed,
> >> but that is a new-kernel-only kind of thing.
> > 
> > Right - I'm wondering if any such changes as propsed here are now
> > obsolted already by khwrngd?
> > 
> 
> In this case, yes, khwrngd would be a better solution for current kernels.

I think that's OK with me.

What's the suggested value for rng->quality, though, for virtio-rng
that I can use to ensure the kthread starts?

Should I use the 700 (70%) as proposed in the original patchset?  I'm
not exactly sure how that value will be used as well..


		Amit
