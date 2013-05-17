Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592Ab3EQW0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:26:43 -0400
Received: from www.sr71.net ([198.145.64.142]:43435 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756824Ab3EQW0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 18:26:41 -0400
Message-ID: <5196AE9D.2030902@sr71.net>
Date: Fri, 17 May 2013 15:26:37 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
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
        Joe Perches <joe@perches.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Hugh Dickens <hughd@google.com>, Paul Mackerras <paulus@samba.org>,
        Heesub Shin <heesub.shin@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv10 1/4] debugfs: add get/set for atomic types
References: <1368052661-27143-1-git-send-email-sjenning@linux.vnet.ibm.com> <1368052661-27143-2-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1368052661-27143-2-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 03:37 PM, Seth Jennings wrote:
> +struct dentry *debugfs_create_atomic_t(const char *name, umode_t mode,
> +				 struct dentry *parent, atomic_t *value)
> +{

lib/fault_inject.c has something that looks pretty similar:

static struct dentry *debugfs_create_atomic_t(const char *name, umode_t
 mode, struct dentry *parent, atomic_t *value)

should add even more of an argument to merge this patch _now_, and
separately from the rest of zswap.
