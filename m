Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab3BRTci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 14:32:38 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41053 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab3BRTch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 14:32:37 -0500
Message-ID: <512281BB.30906@linux.vnet.ibm.com>
Date: Mon, 18 Feb 2013 13:32:11 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ric Mason <ric.masonn@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Joe Perches <joe@perches.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCHv5 7/8] zswap: add swap page writeback support
References: <1360780731-11708-1-git-send-email-sjenning@linux.vnet.ibm.com> <1360780731-11708-8-git-send-email-sjenning@linux.vnet.ibm.com> <511F22FB.4010607@gmail.com>
In-Reply-To: <511F22FB.4010607@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021819-5806-0000-0000-00001FCB74EB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2013 12:11 AM, Ric Mason wrote:
> On 02/14/2013 02:38 AM, Seth Jennings wrote:
<snip>
>> +/*******************************************
>> +* page pool for temporary compression result
>> +********************************************/
>> +#define ZSWAP_TMPPAGE_POOL_PAGES 16
> 
> Why not the number of online cpu?
> 

While the number of online cpus can change, it could better than this
fixed value.

You're the second person to mention this, so I'll fix it up.

Thanks,
Seth

