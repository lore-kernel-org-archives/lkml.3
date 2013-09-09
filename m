Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab3IIQaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:30:30 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44269 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab3IIQa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:30:29 -0400
Date: Mon, 9 Sep 2013 11:29:09 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: minchan@kernel.org, bob.liu@oracle.com, weijie.yang.kh@gmail.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] mm/zswap: avoid unnecessary page scanning
Message-ID: <20130909162909.GB4701@variantweb.net>
References: <000701ceaac0$71c43590$554ca0b0$%yang@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000701ceaac0$71c43590$554ca0b0$%yang@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090916-9332-0000-0000-0000015B1D16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 01:16:45PM +0800, Weijie Yang wrote:
> add SetPageReclaim before __swap_writepage so that page can be moved to the
> tail of the inactive list, which can avoid unnecessary page scanning as this
> page was reclaimed by swap subsystem before.
> 
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>

Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

