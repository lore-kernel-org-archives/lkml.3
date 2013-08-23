Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab3HWIHC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 04:07:02 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:26802 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab3HWIG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 04:06:59 -0400
Message-ID: <5217167E.2060904@huawei.com>
Date: Fri, 23 Aug 2013 15:59:58 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <brouer@redhat.com>, <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: ADSL/ATM linklayer tc shaping regression fix commits for stable
References: <20130821140350.2b953007@redhat.com> <20130821.112023.744177612387539958.davem@davemloft.net> <20130822100426.39be319d@redhat.com> <20130822.012348.1370012681436362922.davem@davemloft.net>
In-Reply-To: <20130822.012348.1370012681436362922.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 2013/8/22 16:23, David Miller wrote:
> From: Jesper Dangaard Brouer <brouer@redhat.com>
> Date: Thu, 22 Aug 2013 10:04:26 +0200
> 
>> So, for future reference:
>>
>> Stable patches for the networking tree, I should:
>> 1) check http://patchwork.ozlabs.org/bundle/davem/stable/?state=*
>>    to see if my patch is already on your stable queue
>> 2) if not, ask you and cc netdev@vger.kernel.org
>> 3) you will handle the interaction with Greg and stable@vger.kernel.org
>>
>> Correct?
> 
> Yes, and that's how it's been with the networking for years.
> 

How about these two stable requests?

http://article.gmane.org/gmane.linux.kernel.stable/61247/match=weidong
http://article.gmane.org/gmane.linux.kernel.stable/61248/match=weidong

