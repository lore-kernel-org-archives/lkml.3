Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab3ALC3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 21:29:51 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:55006 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754446Ab3ALC3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 21:29:50 -0500
Message-ID: <1357957789.2168.11.camel@joe-AO722>
Subject: Re: mmotm 2013-01-11-15-47 uploaded (x86 asm-offsets broken)
From: Joe Perches <joe@perches.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@infradead.org>, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org
Date: Fri, 11 Jan 2013 18:29:49 -0800
In-Reply-To: <20130112131713.749566c8d374cd77b1f2885e@canb.auug.org.au>
References: <20130111234813.170A620004E@hpza10.eem.corp.google.com>
	 <50F0BFAA.10902@infradead.org>
	 <20130112131713.749566c8d374cd77b1f2885e@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-01-12 at 13:17 +1100, Stephen Rothwell wrote:
> On Fri, 11 Jan 2013 17:43:06 -0800 Randy Dunlap <rdunlap@infradead.org> wrote:
> >
> > b0rked.
> > 
> > Some (randconfig?) causes this set of errors:

I guess that's when CONFIG_HZ is not an even divisor of 1000.
I suppose this needs to be worked on a bit more.


