Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbaIONFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 09:05:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbaIONFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 09:05:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140910212154.10752.23343.stgit@warthog.procyon.org.uk>
References: <20140910212154.10752.23343.stgit@warthog.procyon.org.uk>
To: jmorris@namei.org
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] KEYS: Miscellaneous fixes
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <27396.1410786297.1@warthog.procyon.org.uk>
Date: Mon, 15 Sep 2014 14:04:57 +0100
Message-ID: <27397.1410786297@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Thanks for pushing the first patch.  Any thoughts on what to do with the
remaining patches?  #5 and #6 at least ought to go upstream as there's a
potential memory leak fixed and #2 because the keyutils testsuite is failing
without it.  From what Mimi says, I think she's withdrawn her objection to #2.

Thanks,
David
