Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbaG2QD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:03:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbaG2QD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:03:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <53CE886B.6030306@adfin.com>
References: <53CE886B.6030306@adfin.com> <cover.1406043029.git.milosz@adfin.com>
To: Milosz Tanski <milosz@adfin.com>
Cc: dhowells@redhat.com, linux-cachefs@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "NeilBrown" <neilb@suse.de>, "Shantanu Goel" <sgoel01@yahoo.com>
Subject: Re: [PATCH 3/3] FS-Cache: refcount becomes corrupt under vma preasure.
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <28960.1406649799.1@warthog.procyon.org.uk>
Date: Tue, 29 Jul 2014 17:03:19 +0100
Message-ID: <28961.1406649799@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks okay, but no S-o-b line.

David
