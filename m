Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbaKQT3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:29:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbaKQT3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:29:03 -0500
Date: Mon, 17 Nov 2014 14:28:52 -0500
From: Johannes Weiner <jweiner@redhat.com>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Larry Woodman <lwoodman@redhat.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: do not overwrite reserved pages counter at show_mem()
Message-ID: <20141117192852.GA1678@phnom.home.cmpxchg.org>
References: <e34cbf786f7c16d4330889825aa5b13141cc085c.1415989668.git.aquini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e34cbf786f7c16d4330889825aa5b13141cc085c.1415989668.git.aquini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 01:34:29PM -0500, Rafael Aquini wrote:
> Minor fixlet to perform the reserved pages counter aggregation
> for each node, at show_mem()
> 
> Signed-off-by: Rafael Aquini <aquini@redhat.com>

ACK
