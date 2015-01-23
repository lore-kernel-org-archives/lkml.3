Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbbAWX61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 18:58:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbbAWX6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 18:58:24 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1422050221-28345-1-git-send-email-holler@ahsoftware.de>
References: <1422050221-28345-1-git-send-email-holler@ahsoftware.de> <1421976009-9819-1-git-send-email-holler@ahsoftware.de>
To: Alexander Holler <holler@ahsoftware.de>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] modsign: overwrite keys with zero before deleting them
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6704.1422057490.1@warthog.procyon.org.uk>
Date: Fri, 23 Jan 2015 23:58:10 +0000
Message-ID: <6705.1422057490@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Holler <holler@ahsoftware.de> wrote:

> This is for the more paranoid people, also it's
> questionable what paranoid nowadays means.

shred?

David
