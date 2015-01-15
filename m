Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbbAOUQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 15:16:11 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:58654 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbbAOUQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 15:16:08 -0500
Date: Thu, 15 Jan 2015 21:16:05 +0100
From: Michal Hocko <mhocko@suse.cz>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio_balloon: coding style fixes
Message-ID: <20150115201605.GA24130@dhcp22.suse.cz>
References: <1421321941-21111-1-git-send-email-mst@redhat.com>
 <20150115130642.GC7008@dhcp22.suse.cz>
 <20150115134412.GA23874@redhat.com>
 <20150115141308.GH7000@dhcp22.suse.cz>
 <20150115185018.GA31068@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150115185018.GA31068@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 15-01-15 20:50:18, Michael S. Tsirkin wrote:
> On Thu, Jan 15, 2015 at 03:13:08PM +0100, Michal Hocko wrote:
> > On Thu 15-01-15 15:44:12, Michael S. Tsirkin wrote:
[...]
> > > Maybe send patch dropping include/uapi/ from there,
> > > should help drive the volumes down?
> > 
> > This would be an overkill IMO. It would be much more preferable if
> > people actually think about who from the suggested list (either from
> > MAINTAINERS or ./scripts/get_maintainer.pl) should be really added.
> > 
> > [...]
> 
> Yea, think about it, then what?  I've no idea what is linux-abi for, and
> what people subscribed there are interested in. How should I?

https://www.kernel.org/doc/man-pages/linux-api-ml.html

And by no means, I didn't intend to put critique just to you or only
this particular patch. I just grown frustrated because there are so many
patches which are no longer API/ABI related flying here. This was just
an example.

Hi volume of unrelated emails will turn this into another lkml, I am
afraid.
-- 
Michal Hocko
SUSE Labs
