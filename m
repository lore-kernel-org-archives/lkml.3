Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab3AYV4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 16:56:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019Ab3AYV4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 16:56:13 -0500
Message-ID: <5102FF45.4080708@redhat.com>
Date: Fri, 25 Jan 2013 16:55:17 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv2 3/9] staging: zsmalloc: add page alloc/free callbacks
References: <1357590280-31535-1-git-send-email-sjenning@linux.vnet.ibm.com> <1357590280-31535-4-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1357590280-31535-4-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2013 03:24 PM, Seth Jennings wrote:
> This patch allows users of zsmalloc to register the
> allocation and free routines used by zsmalloc to obtain
> more pages for the memory pool.  This allows the user
> more control over zsmalloc pool policy and behavior.
>
> If the user does not wish to control this, alloc_page() and
> __free_page() are used by default.

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
