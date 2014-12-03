Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaLCWcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 17:32:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbaLCWcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 17:32:45 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <BBF8B74B-AECA-4984-81A0-408ED5F8F8C8@oracle.com>
References: <BBF8B74B-AECA-4984-81A0-408ED5F8F8C8@oracle.com> <20141119122238.26494.23666.stgit@warthog.procyon.org.uk> <20141119122249.26494.25661.stgit@warthog.procyon.org.uk>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: dhowells@redhat.com, Carl Hetherington <cth@carlh.net>,
        Neil Brown <neilb@suse.de>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KEYS: request_key() should reget expired keys rather than give EKEYEXPIRED
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15840.1417645918.1@warthog.procyon.org.uk>
Date: Wed, 03 Dec 2014 22:31:58 +0000
Message-ID: <15841.1417645918@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are now upstream.

David
