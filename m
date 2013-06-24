Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751207Ab3FXEXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 00:23:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:25214 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab3FXEXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 00:23:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,926,1363158000"; 
   d="scan'208";a="354651360"
Message-ID: <51C7C9BF.5090305@linux.intel.com>
Date: Mon, 24 Jun 2013 07:23:27 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, donald.c.skidmore@intel.com,
        e1000-devel@lists.sourceforge.net, willemb@google.com,
        erdnetdev@gmail.com, bhutchings@solarflare.com, andi@firstfloor.org,
        hpa@zytor.com, eilong@broadcom.com, or.gerlitz@gmail.com,
        amirv@mellanox.com, alexr@mellanox.com, eliezer@tamir.org.il
Subject: Re: [PATCH v3 net-next 0/1] net: lls select poll support
References: <20130619100421.22132.99447.stgit@ladj378.jer.intel.com> <20130623.184437.1772856342146874217.davem@davemloft.net>
In-Reply-To: <20130623.184437.1772856342146874217.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/06/2013 04:44, David Miller wrote:
> From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> Date: Wed, 19 Jun 2013 13:04:21 +0300
>
>> One question: do we need in sock_poll() to test that sock->sk is not null?
>> (Thanks to Willem de Bruijn for pointing this out.)
>
> We should not have to.
>
> Please clean up various things in this patch:

Ok,
Thanks!
