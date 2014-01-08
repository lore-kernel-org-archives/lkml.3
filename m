Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbaAHHct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 02:32:49 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:30841 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170AbaAHHcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 02:32:42 -0500
Message-ID: <52CCFEFB.201@huawei.com>
Date: Wed, 8 Jan 2014 15:32:11 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Antonio Quartulli <antonio@meshcoding.com>,
        "The list for a Better Approach To Mobile Ad-hoc Networking" 
	<b.a.t.m.a.n@lists.open-mesh.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [B.A.T.M.A.N.] [PATCH v3.6 06/19] batman-adv: use batadv_compare_eth
 for concise
References: <52CCBDA9.8090205@huawei.com> <52CCF906.7000400@meshcoding.com>
In-Reply-To: <52CCF906.7000400@meshcoding.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.22.246]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/1/8 15:06, Antonio Quartulli wrote:
> On 08/01/14 03:53, Ding Tianhong wrote:
>> It is better to use batadv_compate_eth instead of memcpy for
>> concise style.
>>
>> Cc: Marek Lindner <mareklindner@neomailbox.ch>
>> Cc: Simon Wunderlich <sw@simonwunderlich.de>
>> Cc: Antonio Quartulli <antonio@meshcoding.com>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: b.a.t.m.a.n@lists.open-mesh.org
>> Cc: netdev@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Tan Xiaojun <tanxiaojun@huawei.com>
>> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
>> Acked-by: Antonio Quartulli <antonio@meshcoding.com>
> 
> Am I wrong or this patch has already been merged in net-next (together
> with other patches from this series)?
> 
> 
> 
> Regards,
> 
> 
Yes， it is already in net-next, so miss it, thanks.

Regards
Ding

