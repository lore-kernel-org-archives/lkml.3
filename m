Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbaB0NHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:07:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbaB0NHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:07:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140218203346.GG18768@katana>
References: <20140218203346.GG18768@katana> <20140109214954.25590.73057.stgit@warthog.procyon.org.uk>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: dhowells@redhat.com, wolfram@the-dreams.de, khali@linux-fr.org,
        linux-i2c@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c: Add message transfer tracepoints for I2C
Date: Thu, 27 Feb 2014 13:07:24 +0000
Message-ID: <10892.1393506444@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram Sang <wsa@the-dreams.de> wrote:

> 'flags' are u16 and the whole range is needed -> %04x

Done.  Note that %02x does not preclude more digits, but I guess it's better
to have things line up.

> for the address simply %03x should do.

Done.

> And for the buffer: %*phN is difficult to read IMO. What about %*ph? Or
> %*phD at least?

My problem with that is that it increases the length of the output by 50% and
there's a hard limit on how much output we may produce.

David
