Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab3J2Kjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 06:39:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523Ab3J2Kjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 06:39:44 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <526F09B8.9030202@asianux.com>
References: <526F09B8.9030202@asianux.com> <526E3CE2.2070405@asianux.com> <526E6A92.6090301@synopsys.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: dhowells@redhat.com, Vineet Gupta <vineetg76@gmail.com>,
        James Hogan <james.hogan@imgtec.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [PATCH] arch: use ASM_NL instead of ';' for assembler new line character in the macro
Date: Tue, 29 Oct 2013 10:39:29 +0000
Message-ID: <24899.1383043169@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang <gang.chen@asianux.com> wrote:

> > And you also need to fix kernel/modsign_certificate.S as part of same patchset as
> > that is where the problem started in first place.
> > 
> 
> Hmm... can that be another patch?
> 
> For "kernel/modsign_certificate.S", I recommend to expand the macro
> which will shrink code line, either need not include additional header
> file, I feel that will be simpler for both code reader and writers.

I recommend leaving that file alone.  That gets moved to a .S file in patches
queued in the security tree.

David
