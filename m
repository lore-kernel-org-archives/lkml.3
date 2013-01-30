Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab3A3RUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 12:20:12 -0500
Received: from mail.kernel.org ([198.145.19.201]:33689 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277Ab3A3RUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 12:20:09 -0500
Date: Wed, 30 Jan 2013 18:21:59 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: devel@driverdev.osuosl.org, Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH] staging: zsmalloc: remove unused pool name
Message-ID: <20130130172159.GA24760@kroah.com>
References: <1359560212-8818-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <51093F43.2090503@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51093F43.2090503@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 09:41:55AM -0600, Seth Jennings wrote:
> On 01/30/2013 09:36 AM, Seth Jennings wrote:> zs_create_pool()
> currently takes a name argument which is
> > never used in any useful way.
> >
> > This patch removes it.
> >
> > Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> 
> Crud, forgot the Acks...
> 
> Acked-by: Nitin Gupta <ngupta@vflare.org>
> Acked-by: Rik van Riel <riel@redhat.com>

{sigh} you just made me have to edit your patch by hand, you now owe me
a beer...

