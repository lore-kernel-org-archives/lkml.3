Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab3BUGR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 01:17:29 -0500
Received: from ozlabs.org ([203.10.76.45]:58678 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab3BUGR2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 01:17:28 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: joeyli <jlee@suse.com>, David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Josh Boyer <jwboyer@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2] X.509: Support parse long form of length octets in Authority Key Identifier
In-Reply-To: <1361417614.8705.27.camel@linux-s257.site>
References: <1361341056-10745-1-git-send-email-jlee@suse.com> <1794.1361364586@warthog.procyon.org.uk> <1361417614.8705.27.camel@linux-s257.site>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 21 Feb 2013 15:35:23 +1030
Message-ID: <87hal6gsto.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

joeyli <jlee@suse.com> writes:
> 於 三，2013-02-20 於 12:49 +0000，David Howells 提到：
>> Acked-by: David Howells <dhowells@redhat.com>
>> 
>
> Thanks for David's review and confirm.

Should this be CC stable?

Thanks,
Rusty.
