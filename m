Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115AbaCQNbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:31:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbaCQNbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:31:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1394837930-27731-2-git-send-email-lauraa@codeaurora.org>
References: <1394837930-27731-2-git-send-email-lauraa@codeaurora.org> <1394837930-27731-1-git-send-email-lauraa@codeaurora.org>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: dhowells@redhat.com, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Simek <monstr@monstr.eu>, Chen Liqin <liqin.linux@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-cris-kernel@axis.com,
        linux-m32r@ml.linux-m32r.org, microblaze-uclinux@itee.uq.edu.au,
        linux-am33-list@redhat.com
Subject: Re: [PATCH 2/2] Cleanup useless architecture versions of scatterlist.h
Date: Mon, 17 Mar 2014 13:30:16 +0000
Message-ID: <11082.1395063016@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laura Abbott <lauraa@codeaurora.org> wrote:

> There's no need to have an architecture version of scatterlist.h
> if the only thing the file does is include asm-generic/scatterlist.h.
> Switch to the asm-generic versions directly.

Acked-by: David Howells <dhowells@redhat.com> [FRV and MN10300]
