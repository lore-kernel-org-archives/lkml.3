Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861AbaIOWaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:30:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584AbaIOWaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:30:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140915204544.27499.65577.stgit@warthog.procyon.org.uk>
References: <20140915204544.27499.65577.stgit@warthog.procyon.org.uk> <20140915204456.27499.40234.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, vgoyal@redhat.com, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] PKCS#7: Better handling of unsupported crypto [ver #2]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2453.1410820204.1@warthog.procyon.org.uk>
Date: Mon, 15 Sep 2014 23:30:04 +0100
Message-ID: <2454.1410820204@warthog.procyon.org.uk>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> +		switch (pkcs7_validate_trust_one(pkcs7, sinfo, trust_keyring)) {

This should be:

+		ret = pkcs7_validate_trust_one(pkcs7, sinfo, trust_keyring);
+		switch (ret) {

David
