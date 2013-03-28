Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab3C1Eax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 00:30:53 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27762 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab3C1Eaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 00:30:52 -0400
Message-ID: <5153C76E.3050203@oracle.com>
Date: Thu, 28 Mar 2013 12:30:38 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: zsmalloc zbud hybrid design discussion?
References: <ef105888-1996-4c78-829a-36b84973ce65@default>
In-Reply-To: <ef105888-1996-4c78-829a-36b84973ce65@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03/28/2013 04:04 AM, Dan Magenheimer wrote:
> Seth and all zproject folks --
> 
> I've been giving some deep thought as to how a zpage
> allocator might be designed that would incorporate the
> best of both zsmalloc and zbud.
> 
> Rather than dive into coding, it occurs to me that the
> best chance of success would be if all interested parties
> could first discuss (on-list) and converge on a design
> that we can all agree on.  If we achieve that, I don't
> care who writes the code and/or gets the credit or
> chooses the name.  If we can't achieve consensus, at
> least it will be much clearer where our differences lie.
> 
> Any thoughts?

Can't agree more!
Hoping we would agree on a design dealing well with
density/fragmentation/pageframe-reclaim and better integration with MM.
And then working together to implement it.

-- 
Regards,
-Bob
