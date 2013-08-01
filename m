Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab3HAQ3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 12:29:23 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40547 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752838Ab3HAQ3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 12:29:21 -0400
Message-ID: <1375374560.2034.52.camel@joe-AO722>
Subject: Re: [PATCH 0/8] include/net: next set of extern removals
From: Joe Perches <joe@perches.com>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-afs@lists.infradead.org
Date: Thu, 01 Aug 2013 09:29:20 -0700
In-Reply-To: <24958.1375358650@warthog.procyon.org.uk>
References: <cover.1375316912.git.joe@perches.com>
	 <24958.1375358650@warthog.procyon.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-01 at 13:04 +0100, David Howells wrote:
> Joe Perches <joe@perches.com> wrote:
> > Standardize on no extern use on function prototypes
> Can we please standardise on _having_ externs on function prototypes?

Why?

What value is there in using extern for function prototypes?

Your argument for "picking out at a glance"
https://lkml.org/lkml/2013/8/1/237
really doesn't make sense to me.

Basically, anything with parentheses that's not a #define
is an extern.

Exceptions exist for extern function pointers, but those
are fairly unusual anyway.  Outside of netfilter,
extern function pointers are only used about a dozen times
total in the kernel tree.

So, please provide some examples supporting your view.


