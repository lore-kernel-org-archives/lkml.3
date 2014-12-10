Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336AbaLJXLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 18:11:39 -0500
Received: from ozlabs.org ([103.22.144.67]:43427 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758190AbaLJXLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 18:11:38 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Miller <davem@davemloft.net>, mst@redhat.com
Cc: linux-kernel@vger.kernel.org, cornelia.huck@de.ibm.com,
        nab@linux-iscsi.org, pbonzini@redhat.com, thuth@linux.vnet.ibm.com,
        dahi@linux.vnet.ibm.com
Subject: Re: [PATCH v8 00/50] linux: towards virtio-1 guest support
In-Reply-To: <20141208.193339.887400229085902375.davem@davemloft.net>
References: <1417449619-24896-1-git-send-email-mst@redhat.com> <20141208085850.GA19418@redhat.com> <20141208.193339.887400229085902375.davem@davemloft.net>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 11 Dec 2014 09:39:08 +1030
Message-ID: <87oarbnluz.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:
> From: "Michael S. Tsirkin" <mst@redhat.com>
> Date: Mon, 8 Dec 2014 10:58:50 +0200
>
>> On Mon, Dec 01, 2014 at 06:02:42PM +0200, Michael S. Tsirkin wrote:
>>> David, assuming patches are acceptable, I'd like them all to be merged through
>>> virtio or vhost trees to avoid dependency headaches.  Could you please ack
>>> doing that for net related patches, especially these:
>>> 	  tun: move internal flag defines out of uapi
>>> 	  tun: drop most type defines
>>> 	  tun: add VNET_LE flag
>>> 	  tun: TUN_VNET_LE support, fix sparse warnings for virtio headers
>>> 	  macvtap: TUN_VNET_HDR support
>>> 	  vhost/scsi: partial virtio 1.0 support
>>> 	  af_packet: virtio 1.0 stubs
>>> Alternatively, I can prepare a tree with virtio changes and merge
>>> that into your net-next - if Rusty approves, or keeps
>>> silence :)
>> 
>> David, Rusty - ping.
>> Are both of you ok withmerging this through the vhost tree?
>
> No objections on my side.

Ack here, too.

Thanks,
Rusty.
