Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbaJCT5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 15:57:21 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41575 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752719AbaJCT5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 15:57:20 -0400
X-Sasl-enc: H72w5F1QkU0mLV4zyhbY7iGGcTduMYyiK3VRrU838afo 1412366239
Date: Fri, 3 Oct 2014 12:57:18 -0700
From: Greg KH <greg@kroah.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: stable@vger.kernel.org, Amos Kong <akong@redhat.com>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [3.16 stable PATCH v2 1/2] virtio: rng: delay hwrng_register()
 till driver is ready
Message-ID: <20141003195718.GA15407@kroah.com>
References: <e85a877491a10650cd4b14de926707954a91f565.1407830026.git.amit.shah@redhat.com>
 <20140827085539.GG13052@grmbl.mre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140827085539.GG13052@grmbl.mre>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 02:25:39PM +0530, Amit Shah wrote:
> Hey Greg,
> 
> Can you add these two patches to the 3.16 queue?

Now applied.
