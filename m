Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab3A2S4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 13:56:25 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:41228 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab3A2S4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 13:56:22 -0500
Message-ID: <51081B3B.5080001@linux.vnet.ibm.com>
Date: Tue, 29 Jan 2013 12:55:55 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv3 5/6] zswap: add to mm/
References: <1359409767-30092-1-git-send-email-sjenning@linux.vnet.ibm.com> <1359409767-30092-6-git-send-email-sjenning@linux.vnet.ibm.com> <20130129062756.GH4752@blaptop>
In-Reply-To: <20130129062756.GH4752@blaptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012918-2398-0000-0000-00001088C6BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 12:27 AM, Minchan Kim wrote:
<snip>
> On Mon, Jan 28, 2013 at 03:49:26PM -0600, Seth Jennings wrote:
<snip>
>> +/*********************************
>> +* tunables
>> +**********************************/
>> +/* Enable/disable zswap (enabled by default, fixed at boot for now) */
>> +static bool zswap_enabled;
>> +module_param_named(enabled, zswap_enabled, bool, 0);
> 
> It seems default is disable at the moment?

I completely missed what you were saying before.  The comment is
incorrect :)  I'll fix it.

Seth

