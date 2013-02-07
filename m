Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab3BGDSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 22:18:39 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:41636 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3BGDSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 22:18:36 -0500
Message-ID: <1360207111.28557.47.camel@edumazet-glaptop>
Subject: Re: [PATCH 0/2] fix kernel crash with macvtap on top of LRO
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Eilon Greenstein <eilong@broadcom.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>, linux-driver@qlogic.com,
        John Fastabend <john.r.fastabend@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jacob Keller <jacob.e.keller@intel.com>, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net
Date: Wed, 06 Feb 2013 19:18:31 -0800
In-Reply-To: <1360193660.32217.39.camel@deadeye.wl.decadent.org.uk>
References: <cover.1360191528.git.mst@redhat.com>
	 <1360193660.32217.39.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-06 at 23:34 +0000, Ben Hutchings wrote:

> If we want to allow forwarding from LRO then net/ipv4/inet_lro.c also
> needs to set gso_type.

Then, what is dev_disable_lro() purpose ?



