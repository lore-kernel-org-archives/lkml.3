Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbaICAzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 20:55:15 -0400
Received: from tundra.namei.org ([65.99.196.166]:34415 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbaICAzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 20:55:14 -0400
Date: Wed, 3 Sep 2014 10:55:09 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] KEYS: Miscellaneous fixes
In-Reply-To: <13491.1409681276@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.11.1409031054511.16251@namei.org>
References: <alpine.LRH.2.11.1409030056130.7126@namei.org> <20140902125159.9247.11970.stgit@warthog.procyon.org.uk> <13491.1409681276@warthog.procyon.org.uk>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2014, David Howells wrote:

> James Morris <jmorris@namei.org> wrote:
> 
> > Which of these need to go into current Linus?
> > 
> > #4 looks like it should.
> 
> All of them, preferably, though I'm okay with #3 being deferred.

Ok, I applied #3 to next.


-- 
James Morris
<jmorris@namei.org>

