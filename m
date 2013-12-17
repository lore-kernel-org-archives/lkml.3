Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab3LQSbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:31:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113Ab3LQSbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:31:31 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20131215230004.97d14ce7.akpm@linux-foundation.org>
References: <20131215230004.97d14ce7.akpm@linux-foundation.org> <201311201430.56135@pali>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] afs: proc cells and rootcell are writeable
Date: Tue, 17 Dec 2013 18:31:05 +0000
Message-ID: <20263.1387305065@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> David ack?

I've signed it off and added here:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/commit/?h=afs&id=8de69dbba9012693d4f9e7a7e3c12a0b467f85f3

David
