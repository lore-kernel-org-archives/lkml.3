Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965242Ab3DHVfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 17:35:23 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43291 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964970Ab3DHVfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 17:35:22 -0400
Message-ID: <1365456922.2029.18.camel@joe-AO722>
Subject: Re: [PATCH] bitmap: speedup in bitmap_find_free_region when order
 is 0
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chanho Min <chanho.min@lge.com>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        Jiri Kosina <jkosina@suse.cz>, Guennadi Liakhovetski <lg@denx.de>,
        linux-kernel@vger.kernel.org
Date: Mon, 08 Apr 2013 14:35:22 -0700
In-Reply-To: <20130408143037.5fe18306172315fc040329de@linux-foundation.org>
References: <1365387828-24326-1-git-send-email-chanho.min@lge.com>
	 <20130408143037.5fe18306172315fc040329de@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-08 at 14:30 -0700, Andrew Morton wrote:
> On Mon,  8 Apr 2013 11:23:48 +0900 Chanho Min <chanho.min@lge.com> wrote:
> > --- a/lib/bitmap.c
[]
> > +static int __bitmap_find_free_one(unsigned long *bitmap, int bits)
[]
> > +	unsigned long mask = (unsigned long)(~((unsigned long) 0));
> 
> That seems unnecessarily complicated.  "unsigned long mask = -1;" works :)

So would ULONG_MAX or just ~0UL


