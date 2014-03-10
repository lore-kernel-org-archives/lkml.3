Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbaCJBUQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 21:20:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56805 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbaCJBUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 21:20:14 -0400
X-IronPort-AV: E=Sophos;i="4.97,620,1389715200"; 
   d="scan'208";a="9668681"
Message-ID: <531D113C.80709@cn.fujitsu.com>
Date: Mon, 10 Mar 2014 09:11:24 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netlink: switch net_ns only if net is not init_net
References: <5319A3C2.8080001@cn.fujitsu.com> <20140309.190941.472588800498066811.davem@davemloft.net>
In-Reply-To: <20140309.190941.472588800498066811.davem@davemloft.net>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/10 09:17:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/10 09:17:31,
	Serialize complete at 2014/03/10 09:17:31
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2014 07:09 AM, David Miller wrote:

> From: Gu Zheng <guz.fnst@cn.fujitsu.com>
> Date: Fri, 07 Mar 2014 18:47:30 +0800
> 
>> Many netlink users create netlink sock in the init_net, and the
>> switching nes_ns(init_net-->net) is needless in this case. So here
>> we add a pre-check to avoid this.
>>
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> 
> This check is more appropriately placed into sk_change_net() itself.

Agree. I'll update it soon.

Regards,
Gu

> 


