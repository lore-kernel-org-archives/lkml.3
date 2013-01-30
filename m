Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab3A3XeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 18:34:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab3A3XeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 18:34:10 -0500
Date: Wed, 30 Jan 2013 15:34:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Subject: Re: [PATCHv4 2/7] zsmalloc: promote to lib/
Message-Id: <20130130153408.fa099efb.akpm@linux-foundation.org>
In-Reply-To: <51094A39.8050206@linux.vnet.ibm.com>
References: <1359495627-30285-1-git-send-email-sjenning@linux.vnet.ibm.com>
	<1359495627-30285-3-git-send-email-sjenning@linux.vnet.ibm.com>
	<20130129145134.813672cf.akpm@linux-foundation.org>
	<51094A39.8050206@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2013 10:28:41 -0600
Seth Jennings <sjenning@linux.vnet.ibm.com> wrote:

> Question, are you saying that you'd like to see the zsmalloc promotion
> in a separate patch?
> 
> My reason for including the zsmalloc promotion inside the zswap
> patches was that it promoted and introduced a user all together.
> However, I don't have an issue with breaking it out.

Keeping it all in the one series is logical.  I want to see the code
get the normal explain/review/comment process.  Michan has been doing
sterling work here but I don't think the rest of us understand the code
as well as we can and should.
