Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab3FKMtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 08:49:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:33317 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436Ab3FKMti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 08:49:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,845,1363158000"; 
   d="scan'208";a="351448381"
Message-ID: <51B71CDC.1040004@linux.intel.com>
Date: Tue, 11 Jun 2013 15:49:32 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, donald.c.skidmore@intel.com,
        e1000-devel@lists.sourceforge.net, willemb@google.com,
        erdnetdev@gmail.com, bhutchings@solarflare.com, andi@firstfloor.org,
        hpa@zytor.com, eilong@broadcom.com, or.gerlitz@gmail.com,
        amirv@mellanox.com, eliezer@tamir.org.il
Subject: Re: [PATCH v10 net-next 0/6] net: low latency Ethernet device polling
References: <51B68AA6.1050105@linux.intel.com> <20130610.212443.1096102996038709384.davem@davemloft.net> <51B6C87B.70101@linux.intel.com> <20130611.011427.2250431661196003301.davem@davemloft.net>
In-Reply-To: <20130611.011427.2250431661196003301.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 11:14, David Miller wrote:
> From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> Date: Tue, 11 Jun 2013 09:49:31 +0300
>
>> I would like to hear opinions on what needs to be added to make this
>> feature complete.
>
> I actually would like to see the Kconfig option go away, that's
> my only request.

OK,

I will send a patch for this when I submit the socket option patch.

-Eliezer
