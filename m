Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560Ab3IBNwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 09:52:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758510Ab3IBNwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 09:52:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: joe@perches.com, akpm@linux-foundation.org, hannes@stressinduktion.org
cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Please discard "checkpatch: warn when using extern with function prototypes in .h files"
Date: Mon, 02 Sep 2013 14:51:33 +0100
Message-ID: <9606.1378129893@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I noticed that a patch got committed to checkpatch to complain about function
prototypes prefixed by "extern".

Please discard/revert this patch:

	commit 7cd0f806622836e386ef18ad1950a9a729803019
	Author: Joe Perches <joe@perches.com>
	Date:   Wed Aug 28 10:16:00 2013 +1000
	checkpatch: warn when using extern with function prototypes in .h files

	Using the extern keyword on function prototypes is superfluous visual
	noise so suggest removing it.

This is inaccurate.  It's actually a useful visual cue - so if anything, please
make checkpatch indicate that it be added to all future function prototypes.

David
