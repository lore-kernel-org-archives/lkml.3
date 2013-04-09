Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936878Ab3DIDSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 23:18:24 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45809 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934544Ab3DIDSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 23:18:23 -0400
Message-ID: <1365477500.2012.5.camel@joe-AO722>
Subject: Re: [PATCH v2] bitmap: speedup in bitmap_find_free_region when
 order is 0
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chanho Min <chanho.min@lge.com>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        Jiri Kosina <jkosina@suse.cz>, Guennadi Liakhovetski <lg@denx.de>,
        linux-kernel@vger.kernel.org
Date: Mon, 08 Apr 2013 20:18:20 -0700
In-Reply-To: <20130408201001.f4c74887.akpm@linux-foundation.org>
References: <1365475486-14371-1-git-send-email-chanho.min@lge.com>
	 <20130408201001.f4c74887.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-08 at 20:10 -0700, Andrew Morton wrote:
> > --- a/lib/bitmap.c
[]
> > +	for (i = 0 ; i < nlongs_reg ; i++) {
> 
> No space before the semicolon, please.  checkpatch should warn about
> this but it seems to be broken.

There's no specific CodingStyle violation here
Adding --strict does bleat though.

# check for whitespace before a non-naked semicolon
		if ($line =~ /^\+.*\S\s+;/) {
			CHK("SPACING",
			    "space prohibited before semicolon\n" . $herecurr);
		}


