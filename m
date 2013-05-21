Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab3EUImb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 04:42:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:45262 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291Ab3EUIm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 04:42:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,713,1363158000"; 
   d="scan'208";a="305580614"
Message-ID: <519B336F.9090108@linux.intel.com>
Date: Tue, 21 May 2013 11:42:23 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: or.gerlitz@gmail.com, eilong@broadcom.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jesse.brandeburg@intel.com,
        donald.c.skidmore@intel.com, e1000-devel@lists.sourceforge.net,
        willemb@google.com, andi@firstfloor.org, hpa@zytor.com,
        eliezer@tamir.org.il
Subject: Re: [PATCH v3 net-next 3/4] ixgbe: Add support for ndo_ll_poll
References: <1369120003.25971.2.camel@lb-tlvb-eilong.il.broadcom.com> <20130521.001444.1361294042663568537.davem@davemloft.net> <CAJZOPZJTA9A8T4R8MtRCeqcYj3XJWFCXF+ojmEqza5TMj-6G+w@mail.gmail.com> <20130521.013912.96249995742935192.davem@davemloft.net>
In-Reply-To: <20130521.013912.96249995742935192.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/05/2013 11:39, David Miller wrote:
> From: Or Gerlitz <or.gerlitz@gmail.com>
> Date: Tue, 21 May 2013 11:24:41 +0300
>
>> On Tue, May 21, 2013 at 10:14 AM, David Miller <davem@davemloft.net> wrote:
>>> From: "Eilon Greenstein" <eilong@broadcom.com>
>>> Date: Tue, 21 May 2013 10:06:43 +0300
>>>
>>>> Hopefully this series will be accepted so we can send follow up support
>>>> for the bnx2x as well.
>>>
>>> I think in two or three more iterations it will be merged.
>>>
>>> There are no objections on the fundamentals, it's just implementation
>>> details and coding style at this point.
>>
>> Dave, sorry, I might be a bit behind the rest of the reviewers, but I
>> just fail to understand nor find any reference that explains the
>> module param of ixgbe nor it makes sense to me to merge that piece of
>> the code upstream (its not for staging, correct?), as I wrote here
>> http://marc.info/?l=linux-netdev&m=136908123432072&w=2 basically, I
>> know you're not a great fun of module params (to say the least) and
>> surely not something named  "allow_unsafe_removal", thoughts?
>
> It's one of those "implementation details", I hate it too.

I'm open to suggestions.
