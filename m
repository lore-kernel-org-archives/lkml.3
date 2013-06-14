Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab3FNI5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 04:57:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab3FNI5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 04:57:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <9fc3b9d2c9dd12c74aab5115a3c50b9eb3ae76d5.1371177118.git.joe@perches.com>
References: <9fc3b9d2c9dd12c74aab5115a3c50b9eb3ae76d5.1371177118.git.joe@perches.com> <cover.1371177118.git.joe@perches.com>
To: Joe Perches <joe@perches.com>
Cc: dhowells@redhat.com, Jiri Kosina <trivial@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [Trivial PATCH 02/33] frv: Convert use of typedef ctl_table to struct ctl_table
Date: Fri, 14 Jun 2013 09:57:43 +0100
Message-ID: <7254.1371200263@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These look okay.  Feel free to add my Acked-by.  I presume they can't become
const also?

David
