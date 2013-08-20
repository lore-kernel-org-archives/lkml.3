Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab3HTRBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:01:10 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:39021 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab3HTRBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:01:08 -0400
Date: Tue, 20 Aug 2013 21:01:05 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Pavel Emelyanov <xemul@parallels.com>, Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Zijlstra <peterz@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -mm] docs: Document soft dirty behaviour for freshly
 created memory regions
Message-ID: <20130820170105.GM18673@moon>
References: <20130820153132.GK18673@moon>
 <5213A002.7020408@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5213A002.7020408@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 09:57:38AM -0700, Randy Dunlap wrote:
> >  
> > +  While in most cases tracking memory changes by #PF-s is more than enough
>                                                                        enough,

?

For the rest -- thanks a LOT Randy, I'll update.
