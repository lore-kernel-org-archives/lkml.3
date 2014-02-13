Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaBMPyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 10:54:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbaBMPyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 10:54:49 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, bfields@fieldses.org, hch@infradead.org,
        akpm@linux-foundation.org, zab@redhat.com, jack@suse.cz,
        luto@amacapital.net, mszeredi@suse.cz
Subject: Re: [PATCH 00/13] cross rename v4
Date: Thu, 13 Feb 2014 15:54:14 +0000
Message-ID: <19258.1392306854@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If we're going to be adding a new rename inode op, can we make it take a flag
to white out the source for union type things?  This would mean that
rename-and-white-out can be done atomically.

David
