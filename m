Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934833Ab3DKRUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:20:39 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25411 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab3DKRUi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:20:38 -0400
MIME-Version: 1.0
Message-ID: <399a2a41-fa4d-41d9-80aa-5b4c51fee68e@default>
Date: Thu, 11 Apr 2013 10:17:56 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>
Subject: RE: [PATCH 00/10] staging: zcache/ramster: fix and ramster/debugfs
 improvement
References: <<1365553560-32258-1-git-send-email-liwanp@linux.vnet.ibm.com>>
In-Reply-To: <<1365553560-32258-1-git-send-email-liwanp@linux.vnet.ibm.com>>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6668.5000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Wanpeng Li [mailto:liwanp@linux.vnet.ibm.com]
> Sent: Tuesday, April 09, 2013 6:26 PM
> To: Greg Kroah-Hartman
> Cc: Dan Magenheimer; Seth Jennings; Konrad Rzeszutek Wilk; Minchan Kim; linux-mm@kvack.org; linux-
> kernel@vger.kernel.org; Andrew Morton; Bob Liu; Wanpeng Li
> Subject: [PATCH 00/10] staging: zcache/ramster: fix and ramster/debugfs improvement
> 
> Fix bugs in zcache and rips out the debug counters out of ramster.c and
> sticks them in a debug.c file. Introduce accessory functions for counters
> increase/decrease, they are available when config RAMSTER_DEBUG, otherwise
> they are empty non-debug functions. Using an array to initialize/use debugfs
> attributes to make them neater. Dan Magenheimer confirm these works
> are needed. http://marc.info/?l=linux-mm&m=136535713106882&w=2
> 
> Patch 1~2 fix bugs in zcache
> 
> Patch 3~8 rips out the debug counters out of ramster.c and sticks them
> 		  in a debug.c file
> 
> Patch 9 fix coding style issue introduced in zcache2 cleanups
>         (s/int/bool + debugfs movement) patchset
> 
> Patch 10 add how-to for ramster

Note my preference to not apply patch 2of10 (which GregKH may choose
to override), but for all, please add my:
Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
