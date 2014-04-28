Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaD1Fy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 01:54:29 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:55221 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaD1Fy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 01:54:27 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: agruen@kernel.org, bfields@fieldses.org, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, dhowells@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V1 00/22]  New ACL format for better NFSv4 acl interoperability
In-Reply-To: <20140428043909.GA26778@infradead.org>
References: <1398615293-22931-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20140428043909.GA26778@infradead.org>
User-Agent: Notmuch/0.18~rc0+2~gbc64cdc (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 28 Apr 2014 11:24:08 +0530
Message-ID: <87wqeaatj3.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042805-6102-0000-0000-000005751255
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> This doesn't address any or the previous points:
>
>  - common implementation instead of the godawful boilerplate code
>    (and we even fixed most of this for Posix ACL by now, so even less
>    reason to do the same crap again!)

We already do that with richacl. Richacl already have most of the
details implemented in common code. Comparing to recent posix acl
changes we could still simplify chmod and xattr bits. I will do that
in the next update. 

>  - common data structure with Posix ACLs
>

Can you explain this ?. Why do we want to do that ? 


> And of course no real explanation why we need the braindead access/deny
> scheme at how it will get properly integrated with the system.
>
> So in this for a clear NAK.

-aneesh

