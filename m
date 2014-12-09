Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbaLIAdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 19:33:46 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58712 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbaLIAdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 19:33:45 -0500
Date: Mon, 08 Dec 2014 19:33:39 -0500 (EST)
Message-Id: <20141208.193339.887400229085902375.davem@davemloft.net>
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org, cornelia.huck@de.ibm.com, rusty@au1.ibm.com,
        nab@linux-iscsi.org, pbonzini@redhat.com, thuth@linux.vnet.ibm.com,
        dahi@linux.vnet.ibm.com
Subject: Re: [PATCH v8 00/50] linux: towards virtio-1 guest support
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141208085850.GA19418@redhat.com>
References: <1417449619-24896-1-git-send-email-mst@redhat.com>
	<20141208085850.GA19418@redhat.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Dec 2014 16:33:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Mon, 8 Dec 2014 10:58:50 +0200

> On Mon, Dec 01, 2014 at 06:02:42PM +0200, Michael S. Tsirkin wrote:
>> David, assuming patches are acceptable, I'd like them all to be merged through
>> virtio or vhost trees to avoid dependency headaches.  Could you please ack
>> doing that for net related patches, especially these:
>> 	  tun: move internal flag defines out of uapi
>> 	  tun: drop most type defines
>> 	  tun: add VNET_LE flag
>> 	  tun: TUN_VNET_LE support, fix sparse warnings for virtio headers
>> 	  macvtap: TUN_VNET_HDR support
>> 	  vhost/scsi: partial virtio 1.0 support
>> 	  af_packet: virtio 1.0 stubs
>> Alternatively, I can prepare a tree with virtio changes and merge
>> that into your net-next - if Rusty approves, or keeps
>> silence :)
> 
> David, Rusty - ping.
> Are both of you ok withmerging this through the vhost tree?

No objections on my side.
