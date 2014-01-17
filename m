Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbaAQF6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 00:58:17 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:37955 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaAQF6Q (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Fri, 17 Jan 2014 00:58:16 -0500
Subject: Re: [PATCH] MODSIGN: Fix including certificate twice when the
 signing_key.x509
From: joeyli <jlee@suse.com>
To: David Howells <dhowells@redhat.com>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Marek <mmarek@suse.com>
In-Reply-To: <10837.1389875463@warthog.procyon.org.uk>
References: <1389249983-31265-1-git-send-email-jlee@suse.com>
	 <10837.1389875463@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Jan 2014 13:56:25 +0800
Message-ID: <1389938185.24105.298.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2014-01-16 於 12:31 +0000，David Howells 提到：
> 
> Are you asking for this to go upstream or into my devel-pekey branch?
> 
> If upstream you want it to go upstream, I presume commit
> d7ec435fdd03cfee70dba934ee384acc87bd6d00 doesn't fix the problem?
> 
> David 

You are right. I tried the d7ec435 patch fixed issue. Please ignore my
patch.


Thanks a lot!
Joey Lee

