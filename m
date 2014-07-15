Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991AbaGONQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:16:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758734AbaGONQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:16:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1405413956-2772-1-git-send-email-lftan@altera.com>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
To: Ley Foon Tan <lftan@altera.com>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        lftan.linux@gmail.com, cltang@codesourcery.com
Subject: Re: [PATCH v2 00/29] nios2 Linux kernel port
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4212.1405430178.1@warthog.procyon.org.uk>
Date: Tue, 15 Jul 2014 14:16:18 +0100
Message-ID: <4213.1405430178@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ley Foon Tan <lftan@altera.com> wrote:

> Nios2 GCC port is in mainline and will be in the FSF 4.9 release.

I managed to build a nios2-linux-gnu cross compiler from gcc-4.9.0 that I can
add to the Fedora cross-compiler set.  I can't build libgcc without kernel
headers, though:-/

David
