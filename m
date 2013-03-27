Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab3C0UEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 16:04:47 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:23990 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab3C0UEp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 16:04:45 -0400
MIME-Version: 1.0
Message-ID: <ef105888-1996-4c78-829a-36b84973ce65@default>
Date: Wed, 27 Mar 2013 13:04:25 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Bob Liu <bob.liu@oracle.com>, Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: zsmalloc zbud hybrid design discussion?
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6668.5000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seth and all zproject folks --

I've been giving some deep thought as to how a zpage
allocator might be designed that would incorporate the
best of both zsmalloc and zbud.

Rather than dive into coding, it occurs to me that the
best chance of success would be if all interested parties
could first discuss (on-list) and converge on a design
that we can all agree on.  If we achieve that, I don't
care who writes the code and/or gets the credit or
chooses the name.  If we can't achieve consensus, at
least it will be much clearer where our differences lie.

Any thoughts?

Thanks,
Dan
