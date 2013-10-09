Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908Ab3JIIM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 04:12:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952Ab3JIIMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 04:12:25 -0400
Date: Wed, 9 Oct 2013 11:13:54 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, edumazet@google.com, xemul@parallels.com
Subject: Re: [PATCH] tun: don't look at current when non-blocking
Message-ID: <20131009081354.GA30882@redhat.com>
References: <20131006182512.GA16504@redhat.com>
 <20131008.154614.1435858706789904414.davem@davemloft.net>
 <5254F6CF.8080606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5254F6CF.8080606@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 02:25:19PM +0800, Jason Wang wrote:
> On 10/09/2013 03:46 AM, David Miller wrote:
> > From: "Michael S. Tsirkin" <mst@redhat.com>
> > Date: Sun, 6 Oct 2013 21:25:12 +0300
> >
> >> We play with a wait queue even if socket is
> >> non blocking. This is an obvious waste.
> >> Besides, it will prevent calling the non blocking
> >> variant when current is not valid.
> >>
> >> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Applied and queued up for -stable, thanks.
> > --
> 
> Michael, I believe this is just an optimization or a required patch of
> your following patches. So no need go for stable?

I don't think it's required for stable.
