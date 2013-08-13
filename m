Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954Ab3HMXGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 19:06:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab3HMXGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 19:06:45 -0400
Message-ID: <520ABBFD.7080004@redhat.com>
Date: Tue, 13 Aug 2013 19:06:37 -0400
From: Vlad Yasevich <vyasevic@redhat.com>
Reply-To: vyasevic@redhat.com
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: ast@fiberby.net, stephen@networkplumber.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtnetlink: rtnl_bridge_getlink: Call nlmsg_find_attr()
 with ifinfomsg header
References: <52090C26.4090001@fiberby.net> <1376325009-8399-1-git-send-email-ast@fiberby.net> <52093E29.5010604@redhat.com> <20130813.155443.1789890841731289313.davem@davemloft.net>
In-Reply-To: <20130813.155443.1789890841731289313.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 06:54 PM, David Miller wrote:
> From: Vlad Yasevich <vyasevic@redhat.com>
> Date: Mon, 12 Aug 2013 15:57:29 -0400
>
>> On 08/12/2013 12:30 PM, Asbjoern Sloth Toennesen wrote:
>>> Fix the iproute2 command `bridge vlan show`, after switching from
>>> rtgenmsg to ifinfomsg.
>>>
>>> Signed-off-by: Asbjoern Sloth Toennesen <ast@fiberby.net>
>>
>>
>> Thanks..  I've still been using an older iproute version and didn't
>> see this.
>>
>>
>> Reviewed-by: Vlad Yasevich <vyasevich@gmail.com>
>
> What introduced this regression?
>

ast explained it in his header message (Bridge VLAN kernel/iproute2 
incompatibility)

-vlad
