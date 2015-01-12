Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbbALWF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 17:05:58 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54598 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbbALWF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 17:05:56 -0500
Date: Mon, 12 Jan 2015 17:05:51 -0500 (EST)
Message-Id: <20150112.170551.2256606651908771184.davem@davemloft.net>
To: pagupta@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jasowang@redhat.com,
        mst@redhat.com, dgibson@redhat.com, vfalico@gmail.com,
        edumazet@google.com, vyasevic@redhat.com, hkchu@google.com,
        wuzhy@linux.vnet.ibm.com, xemul@parallels.com, therbert@google.com,
        bhutchings@solarflare.com, xii@google.com, stephen@networkplumber.org,
        jiri@resnulli.us, sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH v5 net-net 0/2] Increase the limit of tuntap queues
From: David Miller <davem@davemloft.net>
In-Reply-To: <1421043089-30103-1-git-send-email-pagupta@redhat.com>
References: <1421043089-30103-1-git-send-email-pagupta@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 12 Jan 2015 14:05:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pankaj Gupta <pagupta@redhat.com>
Date: Mon, 12 Jan 2015 11:41:27 +0530

> Networking under KVM works best if we allocate a per-vCPU rx and tx
> queue in a virtual NIC. This requires a per-vCPU queue on the host side.
> Modern physical NICs have multiqueue support for large number of queues.
> To scale vNIC to run multiple queues parallel to maximum number of vCPU's
> we need to increase number of queues support in tuntap.   

Series applied, thanks for following up on this.
