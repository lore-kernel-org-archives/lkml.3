Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab3EATGC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 15:06:02 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41729 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120Ab3EATFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 15:05:52 -0400
Date: Wed, 01 May 2013 15:05:48 -0400 (EDT)
Message-Id: <20130501.150548.1959140741961524114.davem@davemloft.net>
To: mst@redhat.com
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, asias@redhat.com,
        brian@purestorage.com, hch@lst.de, joern@logfs.org,
        mark.d.rustad@intel.com, martin.petersen@oracle.com,
        nab@linux-iscsi.org, ogerlitz@mellanox.com,
        yongjun_wei@trendmicro.com.cn
Subject: Re: [PULL] vhost: cleanups and fixes for 3.10
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130501150130.GA21230@redhat.com>
References: <20130501150130.GA21230@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 01 May 2013 12:05:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Wed, 1 May 2013 18:01:31 +0300

> Please pull the following vhost core updates for 3.10 -
> they affect both vhost-net and vhost-scsi devices.
> They also *depend* on both net-next and target-pending.  Since Linus
> merged target-pending but not net-next at this point, merging through
> the net tree seems to make sense.

I don't have target-pending in my tree though and I'm not going to pull
it in just for this.

Since you have such a multi-dependency situation, just ask Linus to pull
this directly after I push net-next to him, which should be later today.

Thanks.
