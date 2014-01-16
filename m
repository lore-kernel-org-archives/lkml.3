Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbaAPEE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:04:58 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:40743 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaAPEEz (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Wed, 15 Jan 2014 23:04:55 -0500
Subject: Re: [PATCH] MODSIGN: Fix including certificate twice when the
 signing_key.x509
From: joeyli <jlee@suse.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Marek <mmarek@suse.com>
In-Reply-To: <87eh49x3hh.fsf@rustcorp.com.au>
References: <1389249983-31265-1-git-send-email-jlee@suse.com>
	 <87eh49x3hh.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Jan 2014 12:03:05 +0800
Message-ID: <1389844985.24105.288.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 三，2014-01-15 於 15:09 +1030，Rusty Russell 提到：
> >
> > v2:
> > Using '$(shell /bin/pwd)' instead of '$(shell pwd)' for more
> reliable
> > between different shells
> 
> Hmm, that's not a great test for equality.  How about:
> 
>      ifneq ($(realpath .), $(realpath $(srctree)))
> 
> That should cover all the cases.
> 
> Cheers,
> Rusty. 

Yes, it's better!

Thanks for your suggestion, I will send new version with changelog
updated.

Joey Lee

