Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab3GOVJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 17:09:56 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55124 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755296Ab3GOVJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 17:09:55 -0400
Message-ID: <1373922593.2062.36.camel@joe-AO722>
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Willy Tarreau <w@1wt.eu>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Mon, 15 Jul 2013 14:09:53 -0700
In-Reply-To: <1373921779.17876.200.camel@gandalf.local.home>
References: <1373916476.2748.69.camel@dabdike>
	 <1373917517.17876.193.camel@gandalf.local.home>
	 <20130715195505.GE10157@1wt.eu>
	 <1373921779.17876.200.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 16:56 -0400, Steven Rostedt wrote:
> It may not be efficient for maintainers, but as maintainers we should
> spend a bit more time on stable releases.

The MAINTAINERS file specifies a difference between a
section that's Maintained vs Supported.

Do please remember there's a difference between a maintainer
and someone that's paid to support a particular thing.

My feeling is if you're a maintainer you can just say
"use the current version" and not spend even a moments
effort or thought on backports.

When you're getting paid however, different issues...


