Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbaKSUos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:44:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756631AbaKSUoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:44:46 -0500
Date: Wed, 19 Nov 2014 22:44:27 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: pagupta@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jasowang@redhat.com, dgibson@redhat.com, vfalico@gmail.com,
        edumazet@google.com, vyasevic@redhat.com, hkchu@google.com,
        wuzhy@linux.vnet.ibm.com, xemul@parallels.com, therbert@google.com,
        bhutchings@solarflare.com, xii@google.com, stephen@networkplumber.org,
        jiri@resnulli.us, sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH net-net 0/4] Increase the limit of tuntap queues
Message-ID: <20141119204427.GB30994@redhat.com>
References: <1416327778-17716-1-git-send-email-pagupta@redhat.com>
 <20141119.151628.768548269128919029.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141119.151628.768548269128919029.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 03:16:28PM -0500, David Miller wrote:
> From: Pankaj Gupta <pagupta@redhat.com>
> Date: Tue, 18 Nov 2014 21:52:54 +0530
> 
> > - Accept maximum number of queues as sysctl param so that any user space 
> >   application like libvirt can use this value to limit number of queues. Also
> >   Administrators can specify maximum number of queues by updating this sysctl
> >   entry.
> 
> This is the only part I don't like.
> 
> Just let whoever has privileges to configure the tun device shoot
> themselves in the foot if they want to by configuring "too many"
> queues.
> 
> If the virtual entity runs itself out of resources by doing something
> stupid, it's purely their problem.

Well it will run host out of kernel, no?

-- 
MST
