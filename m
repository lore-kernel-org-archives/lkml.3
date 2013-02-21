Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab3BUKIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 05:08:47 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:35239 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab3BUKIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 05:08:45 -0500
Subject: Re: [PATCH v2] X.509: Support parse long form of length octets in
 Authority Key Identifier
From: joeyli <jlee@suse.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <87hal6gsto.fsf@rustcorp.com.au>
References: <1361341056-10745-1-git-send-email-jlee@suse.com>
	 <1794.1361364586@warthog.procyon.org.uk>
	 <1361417614.8705.27.camel@linux-s257.site> <87hal6gsto.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Feb 2013 18:07:46 +0800
Message-ID: <1361441266.8705.33.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2013-02-21 於 15:35 +1030，Rusty Russell 提到：
> joeyli <jlee@suse.com> writes:
> > 於 三，2013-02-20 於 12:49 +0000，David Howells 提到：
> >> Acked-by: David Howells <dhowells@redhat.com>
> >> 
> >
> > Thanks for David's review and confirm.
> 
> Should this be CC stable?
> 
> Thanks,
> Rusty.
> 

IMHO this patch need Cc stable, because kernel got problem to load a
certificate that also provides authorityCertIssuer and
authorityCertSerialNumber.


Thanks a lot!
Joey Lee




