Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbaIPQsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:48:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393AbaIPQsT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:48:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <23655.1410874187@warthog.procyon.org.uk>
References: <23655.1410874187@warthog.procyon.org.uk>
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] KEYS: Fixes for keyrings
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <31999.1410886091.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Tue, 16 Sep 2014 17:48:11 +0100
Message-ID: <32000.1410886091@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> 
> Can you please pull these fixes and send them on upstream:
> 
>  (1) Reinstate the production of EPERM for key types beginning with '.' in
>      requests from userspace.
> 
>  (2) Tidy up the cleanup of PKCS#7 message signed information blocks and fix a
>      bug this made more obvious.

Please ignore this pull request.  To make things easier, I've rebased on the
most recent common ancestor of linus/master and security/next so that you can
pull it into both.  I'll issue another pull request.

David
