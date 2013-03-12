Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102Ab3CLRTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 13:19:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932270Ab3CLRTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 13:19:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+icZUUqSCZeb2JOFv-OSRXAQyD+crvGqg9E0FAUF=+ZAg5vFA@mail.gmail.com>
References: <CA+icZUUqSCZeb2JOFv-OSRXAQyD+crvGqg9E0FAUF=+ZAg5vFA@mail.gmail.com>
To: sedat.dilek@gmail.com
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: Status of union-mount?
Date: Tue, 12 Mar 2013 17:19:28 +0000
Message-ID: <16729.1363108768@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sedat Dilek <sedat.dilek@gmail.com> wrote:

> what's the status of union-mount?

It's being reengineered again to take account of VFS changes that went in in
the last merge window.

> Where does the development happen - in [1]?

On a git tree on my PC - which is occasionally mirrored in [1] when I've got
it working.

David
