Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbaAGSsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 13:48:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58216 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaAGSrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 13:47:53 -0500
Date: Tue, 7 Jan 2014 10:48:21 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Rafael Aquini <aquini@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Vlastimil Babka <vbabka@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.10 075/129] mm/mempolicy: correct putback method for
 isolate pages if failed
Message-ID: <20140107184821.GA4223@kroah.com>
References: <20140106223859.589799655@linuxfoundation.org>
 <20140106223901.757315615@linuxfoundation.org>
 <20140107172659.GC4383@hercules>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140107172659.GC4383@hercules>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 05:26:59PM +0000, Luis Henriques wrote:
> On Mon, Jan 06, 2014 at 02:38:24PM -0800, Greg Kroah-Hartman wrote:
> > 3.10-stable review patch.  If anyone has any objections, please let me know.
> 
> This commit was tagged for 3.12 stable only, so you may want to drop it.

Thanks, somehow missed, that, now dropped.

greg k-h
