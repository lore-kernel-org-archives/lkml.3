Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941AbaE2Qsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:48:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932795AbaE2Qso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:48:44 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        sedat.dilek@gmail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: Unionmount and overlayfs testsuite
Date: Thu, 29 May 2014 17:48:01 +0100
Message-ID: <28592.1401382081@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


http://git.infradead.org/users/dhowells/unionmount-testsuite.git

Check it out and read the README file as to how to drive it.  Sorry, it's a
bit crude.  I may rewrite it in python or perl at some point.

Make sure you turn on CONFIG_LOCKDEP before running it - you don't want to
miss any locking conflicts!

Further tests would be appreciated.  There are no rename tests, for instance.

David
