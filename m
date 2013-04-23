Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab3DWWKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:10:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:22565 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756454Ab3DWWKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 18:10:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,537,1363158000"; 
   d="scan'208";a="299978245"
Date: Tue, 23 Apr 2013 15:10:11 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, hein_tibosch@yahoo.es,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix initconst in lib/decompress.c
Message-ID: <20130423221011.GC19487@tassilo.jf.intel.com>
References: <1366515885-18131-1-git-send-email-andi@firstfloor.org>
 <20130423150209.24d179d9cc508024829aa250@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130423150209.24d179d9cc508024829aa250@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 03:02:09PM -0700, Andrew Morton wrote:
> On Sat, 20 Apr 2013 20:44:45 -0700 Andi Kleen <andi@firstfloor.org> wrote:
> 
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > 
> > diff --git a/lib/decompress.c b/lib/decompress.c
> > index 31a8042..f8fdeda 100644
> > --- a/lib/decompress.c
> > +++ b/lib/decompress.c
> > @@ -38,7 +38,7 @@ struct compress_format {
> >  	decompress_fn decompressor;
> >  };
> >  
> > -static const struct compress_format compressed_formats[] __initdata = {
> > +static const struct compress_format compressed_formats[] __initconst = {
> >  	{ {037, 0213}, "gzip", gunzip },
> >  	{ {037, 0236}, "gzip", gunzip },
> >  	{ {0x42, 0x5a}, "bzip2", bunzip2 },
> 
> That's missing both a changelog and the signed-off-by.  Did your
> scripts break?

I normally don't write a description for initconst patches, as
they should be obvious.

Sorry for the missing Signed-off-by. Hereby added:

Signed-off-by: Andi Kleen <ak@linux.intel.com>

Please let me know if I should resend.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
