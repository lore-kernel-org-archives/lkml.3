Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbaCYMGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 08:06:06 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:21898 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbaCYMGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 08:06:02 -0400
Message-ID: <5331711B.9040405@huawei.com>
Date: Tue, 25 Mar 2014 20:05:47 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
CC: Ben Hutchings <ben@decadent.org.uk>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Andres Bertens <abertensu@yahoo.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3.4 93/99] iwlwifi: always copy first 16 bytes of commands
References: <20140308010611.468206150@linuxfoundation.org> <1553572.xqrhDm938v@tux200s> <1395716117.2832.86.camel@deadeye.wl.decadent.org.uk> <3326096.NJGQSn5Qfa@tux200s>
In-Reply-To: <3326096.NJGQSn5Qfa@tux200s>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.155]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/3/25 17:29, Andreas Sturmlechner wrote:

> Original Message from: Ben Hutchings <ben@decadent.org.uk>
>>
>> One piece of my backport to 3.2.y went missing in the forward-port to
>> 3.4.y.  Can you test 3.4.83 with this patch on top?
>>
>> Ben.
> 
> iwlwifi works with the additional patch, thanks :)
> 
> 
> 


Sorry for the missing part, thanks, Ben.

