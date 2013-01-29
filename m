Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab3A2WtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 17:49:13 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:59980 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab3A2WtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 17:49:11 -0500
Message-ID: <510851E0.8000009@linux.vnet.ibm.com>
Date: Tue, 29 Jan 2013 16:49:04 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
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
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv4 0/7] zswap: compressed swap caching
References: <1359495627-30285-1-git-send-email-sjenning@linux.vnet.ibm.com> <1359497685.16868.11.camel@joe-AO722>
In-Reply-To: <1359497685.16868.11.camel@joe-AO722>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012922-7408-0000-0000-00000C585DED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 04:14 PM, Joe Perches wrote:
> On Tue, 2013-01-29 at 15:40 -0600, Seth Jennings wrote:
>> The code required for the flushing is in a separate patch now
>> as requested.
> 
> What tree does this apply to?
> Both -next and linus fail to compile.

Link to build instruction in the cover letter:

>> NOTE: To build, read this:
>> http://lkml.org/lkml/2013/1/28/586

The complexity is due to a conflict with a zsmalloc patch in Greg's
staging tree that has yet to make its way upstream.

Sorry for the inconvenience.

Seth

