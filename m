Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbaKFM1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:27:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbaKFM1p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:27:45 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <11463.1415275413@warthog.procyon.org.uk>
References: <11463.1415275413@warthog.procyon.org.uk> <545A51CB.6070107@tycho.nsa.gov> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154307.2555.9847.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, Stephen Smalley <sds@tycho.nsa.gov>,
        linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] SELinux: Handle opening of a unioned file
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <31659.1415276858.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Thu, 06 Nov 2014 12:27:38 +0000
Message-ID: <31660.1415276858@warthog.procyon.org.uk>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Good point.  I need to call avc_has_perm() directly.  I don't necessarily have
> an sclass, though, hmmm...

I do have an sclass on the lower file, however, as pointed to by
file_inode(file).

David
