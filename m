Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964870Ab3BMRnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:43:04 -0500
Received: from barbershop.grep.be ([89.106.240.122]:42231 "EHLO
	barbershop.grep.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934504Ab3BMRnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:43:02 -0500
Date: Wed, 13 Feb 2013 18:14:40 +0100
From: Wouter Verhelst <w@uter.be>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, nbd-general@lists.sf.net,
        Paul Clements <Paul.Clements@steeleye.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Nbd] [PATCH 0/3] NBD fixes for caching and block device flags
Message-ID: <20130213171440.GA32217@grep.be>
References: <1360685171-3792-1-git-send-email-pbonzini@redhat.com>
 <20130212134349.579be89a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130212134349.579be89a.akpm@linux-foundation.org>
X-Speed: Gates' Law: Every 18 months, the speed of software halves.
Organization: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 01:43:49PM -0800, Andrew Morton wrote:
> On Tue, 12 Feb 2013 17:06:08 +0100
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> > The first two patches improve the behavior of NBD with respect to the host
> > cache---respectively the server's cache and the client's.  The first adds
> > support for flushing the backing storage, so that NBD is safe against
> > power losses.  The second properly syncs and cleans the client's page
> > cache when an NBD device is disconnected from the server.
> > 
> > The third reports read-only devices properly in sysfs.
> > 
> > Ok for 3.9?  I saw the last NBD patches were applied by Andrew Morton,
> > so I'm CCing him; Paul, please ack them if they are okay.
> 
> I grabbed these and will await Paul's feedback, and a bit more
> changelog detail for [1/3], please.

While we're at it, I'd like to see some updates to the horribly outdated
Documentation/blockdev/nbd.txt, and to see this list (nbd-general)
linked to from the MAINTAINERS file. I'll send a proposed patch shortly.

-- 
Copyshops should do vouchers. So that next time some bureaucracy requires you
to mail a form in triplicate, you can mail it just once, add a voucher, and
save on postage.
