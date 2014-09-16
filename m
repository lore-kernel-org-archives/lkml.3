Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbaIPCPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 22:15:51 -0400
Received: from tundra.namei.org ([65.99.196.166]:34453 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbaIPCPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 22:15:48 -0400
Date: Tue, 16 Sep 2014 12:15:42 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] KEYS: Miscellaneous fixes
In-Reply-To: <27397.1410786297@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.11.1409161215030.10183@namei.org>
References: <20140910212154.10752.23343.stgit@warthog.procyon.org.uk> <27397.1410786297@warthog.procyon.org.uk>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Sep 2014, David Howells wrote:

> Hi James,
> 
> Thanks for pushing the first patch.  Any thoughts on what to do with the
> remaining patches?  #5 and #6 at least ought to go upstream as there's a
> potential memory leak fixed and #2 because the keyutils testsuite is failing
> without it.  From what Mimi says, I think she's withdrawn her objection to #2.

Can you split your pull requests into different branches -- one which is 
for current upstream, and one which is for next?


-- 
James Morris
<jmorris@namei.org>

