Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab3AYQpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:45:46 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59987 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249Ab3AYQpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:45:42 -0500
Message-ID: <5102B690.4090503@linux.vnet.ibm.com>
Date: Fri, 25 Jan 2013 10:45:04 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, devel@driverdev.osuosl.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Johannes Weiner <jweiner@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        Jenifer Hopper <jhopper@us.ibm.com>
Subject: Re: [PATCHv2 5/9] debugfs: add get/set for atomic types
References: <1357590280-31535-1-git-send-email-sjenning@linux.vnet.ibm.com> <1357590280-31535-6-git-send-email-sjenning@linux.vnet.ibm.com> <20130107203219.GA19596@kroah.com> <50EB32FB.30802@linux.vnet.ibm.com>
In-Reply-To: <50EB32FB.30802@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012516-9360-0000-0000-00000FB2A973
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2013 02:41 PM, Seth Jennings wrote:
> On 01/07/2013 02:32 PM, Greg Kroah-Hartman wrote:
>> On Mon, Jan 07, 2013 at 02:24:36PM -0600, Seth Jennings wrote:
>>> debugfs currently lack the ability to create attributes
>>> that set/get atomic_t values.
>>
>> I hate to ask, but why would you ever want to do such a thing?
> 
> There are a few atomic_t statistics in zswap that are valuable to have
> in the debugfs attributes.  Rather than have non-atomic mirrors of all
> of them, as is done in zcache right now (see
> drivers/staging/ramster/zcache-main.c:131), I thought this to be a
> cleaner solution.
> 
> Granted, I personally have no use for the setting part; only the
> getting part.  I only included the setting operations to keep the
> balance and conform with the rest of the debugfs implementation.

Greg, I never did get your ack or rejection here.  Are you ok with
this patch?

Thanks,
Seth

