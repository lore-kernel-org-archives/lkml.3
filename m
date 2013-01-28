Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab3A1RIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 12:08:06 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37446 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756631Ab3A1RIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 12:08:04 -0500
Message-ID: <5106B03E.6070302@linux.vnet.ibm.com>
Date: Mon, 28 Jan 2013 11:07:10 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] staging: zsmalloc: various cleanups/improvments
References: <1359135978-15119-1-git-send-email-sjenning@linux.vnet.ibm.com> <20130128034740.GE3321@blaptop>
In-Reply-To: <20130128034740.GE3321@blaptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012817-5806-0000-0000-00001EDA2BA9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2013 09:47 PM, Minchan Kim wrote:
> Hi Seth,
> 
> On Fri, Jan 25, 2013 at 11:46:14AM -0600, Seth Jennings wrote:
>> These patches are the first 4 patches of the zswap patchset I
>> sent out previously.  Some recent commits to zsmalloc and
>> zcache in staging-next forced a rebase. While I was at it, Nitin
>> (zsmalloc maintainer) requested I break these 4 patches out from
>> the zswap patchset, since they stand on their own.
> 
> [2/4] and [4/4] is okay to merge current zsmalloc in staging but
> [1/4] and [3/4] is dependent on zswap so it should be part of
> zswap patchset.

Just to clarify, patches 1 and 3 are _not_ dependent on zswap.  They
just introduce changes that are only needed by zswap.

Seth

