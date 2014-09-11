Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaIKXgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 19:36:22 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37325 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaIKXgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 19:36:21 -0400
Date: Fri, 12 Sep 2014 01:36:17 +0200
From: Arianna Avanzini <avanzini.arianna@gmail.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        bob.liu@oracle.com, felipe.franciosi@citrix.com, axboe@fb.com
Subject: Re: [PATCH RFC 3/4] xen, blkfront: introduce support for multiple hw
 queues
Message-ID: <20140911233615.GA2052@gmail.com>
Reply-To: avanzini.arianna@gmail.com
References: <1408706404-6614-1-git-send-email-avanzini.arianna@gmail.com>
 <1408706404-6614-4-git-send-email-avanzini.arianna@gmail.com>
 <53F73D29.4020401@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F73D29.4020401@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

thank you for all your comments and sorry if it took so long to reply
and address them.

On Fri, Aug 22, 2014 at 01:52:57PM +0100, David Vrabel wrote:
> On 22/08/14 12:20, Arianna Avanzini wrote:
> > This commit introduces in xen-blkfront actual support for multiple
> > hardware queues. The number of available hardware queues is gathered
> > from the backend via XenStore; in case the expected XenStore key
> > is not available, the frontend defaults to a single I/O ring.
> 
> Can you split this into a part that reactors blkfront handle multiple
> queues and the part that adds the XenStore negotiation for this?
> 

Of course, thank you for the suggestion.

> You will also need to to add documentation for the XenStore keys to the
> blkif.h header in Xen.
> 

Thank you for pointing that out. I'll add the documentation when/if I'll
drop the RFC tag, if it's OK (I'll need to send a separate patch to
xen-devel, I think).


> David

