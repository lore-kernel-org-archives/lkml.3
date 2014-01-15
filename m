Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaAOBSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:18:37 -0500
Received: from mail1.windriver.com ([147.11.146.13]:41788 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaAOBSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:18:34 -0500
Message-ID: <52D5E1CD.2020405@windriver.com>
Date: Wed, 15 Jan 2014 09:18:05 +0800
From: Ying Xue <ying.xue@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <davem@davemloft.net>, <vfalico@redhat.com>, <john.r.fastabend@intel.com>,
        <stephen@networkplumber.org>, <antonio@meshcoding.com>,
        <dmitry.tarnyagin@lockless.no>, <socketcan@hartkopp.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 10/10] net: nl80211: __dev_get_by_index instead
 of dev_get_by_index to find interface
References: <1389685269-18600-1-git-send-email-ying.xue@windriver.com>	 <1389685269-18600-11-git-send-email-ying.xue@windriver.com> <1389701498.23430.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1389701498.23430.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.185]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 08:11 PM, Johannes Berg wrote:
> On Tue, 2014-01-14 at 15:41 +0800, Ying Xue wrote:
> 
>> @@ -2218,10 +2194,6 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
>>  			rdev->wiphy.coverage_class = old_coverage_class;
>>  		}
>>  	}
>> -
>> - bad_res:
>> -	if (netdev)
>> -		dev_put(netdev);
>>  	return result;
> 
> I believe that could be "return 0;" now, which would make the code
> easier to read.
> 

Yes, I will change it in next version.

Thanks,
Ying

> johannes
> 
> 
> 

