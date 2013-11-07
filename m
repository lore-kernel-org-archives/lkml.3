Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3KGP5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:57:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862Ab3KGP5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:57:54 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <527B2A76.2000501@infradead.org>
References: <527B2A76.2000501@infradead.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, lailavrazda1979@gmail.com
Subject: Re: [PATCH] kcore: add Kconfig help text
Date: Thu, 07 Nov 2013 15:57:28 +0000
Message-ID: <15490.1383839848@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> wrote:

> +	  Exports kernel core in ELF format.

"Provides a virtual ELF core file of the live kernel.  This can be read with
gdb and other ELF tools.  No modifications can be made using this mechanism."

maybe?
