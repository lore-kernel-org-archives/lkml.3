Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab3EOWDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 18:03:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab3EOWDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 18:03:32 -0400
Message-ID: <519405D2.3020203@redhat.com>
Date: Wed, 15 May 2013 18:01:54 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Konrad Wilk <konrad.wilk@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@sr71.net>, Joe Perches <joe@perches.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Hugh Dickens <hughd@google.com>, Paul Mackerras <paulus@samba.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCHv11 3/4] zswap: add to mm/
References: <1368448803-2089-1-git-send-email-sjenning@linux.vnet.ibm.com> <1368448803-2089-4-git-send-email-sjenning@linux.vnet.ibm.com> <15c5b1da-132a-4c9e-9f24-bc272d3865d5@default> <20130514163541.GC4024@medulla> <f0272a06-141a-4d33-9976-ee99467f3aa2@default> <20130514225501.GA11956@cerebellum> <4d74f5db-11c1-4f58-97f4-8d96bbe601ac@default> <20130515185506.GA23342@phenom.dumpdata.com> <57917f43-ab37-4e82-b659-522e427fda7f@default> <5193F3CC.8020205@redhat.com> <9a2b2fe9-4694-4cee-9131-a159b58e8bf5@default>
In-Reply-To: <9a2b2fe9-4694-4cee-9131-a159b58e8bf5@default>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 05:36 PM, Dan Magenheimer wrote:

> If you disagree with any of my arguments earlier in this thread,
> please say so.  Else, please reinforce that the MM subsystem
> needs to dynamically adapt to a broad range of workloads,
> which zswap does not (yet) do.  Zswap is not simple, it is
> simplistic*.
>
> IMHO, it may be OK for a driver to be ham-handed in its memory
> use, but that's not OK for something in mm/.

It is functionality that a lot of people want.

IMHO it should be where it has most eyes on it, so its
deficiencies can be fixed. At this point all we know is
that zswap is somewhat simplistic, but we have no idea
yet what its failures modes are in practice.

The only way to find out, is to start using it.

-- 
All rights reversed
