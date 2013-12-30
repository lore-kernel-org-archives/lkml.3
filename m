Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab3L3T7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 14:59:01 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:56920 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932094Ab3L3T67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 14:58:59 -0500
X-IronPort-AV: E=Sophos;i="4.95,575,1384297200"; 
   d="scan'208";a="51042059"
Date: Mon, 30 Dec 2013 20:58:55 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Johannes Berg <johannes@sipsolutions.net>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, kernel-janitors@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/11]  use ether_addr_equal_64bits
In-Reply-To: <1388429761.4410.1.camel@jlt4.sipsolutions.net>
Message-ID: <alpine.DEB.2.02.1312302057420.2209@localhost6.localdomain6>
References: <1388427307-8691-1-git-send-email-Julia.Lawall@lip6.fr>  <1388427307-8691-5-git-send-email-Julia.Lawall@lip6.fr>  (sfid-20131230_182319_112673_F481A1D3) <1388429761.4410.1.camel@jlt4.sipsolutions.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Seems to be missing an "iwlwifi:" or so prefix, but I guess we can add
> it when we take the patch ...

Sorry.  Not sure why that happened.  I'll look into it.

> Is there any way we could catch (sparse, or some other script?) that
> struct reorganising won't break the condition needed ("within a
> structure that contains at least two more bytes")?

What kind of reorganizing could happen?  Do you mean that the programmer 
might do at some time in the future, or something the compiler might do?

julia
