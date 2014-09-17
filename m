Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbaIQXXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 19:23:37 -0400
Received: from tundra.namei.org ([65.99.196.166]:34457 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253AbaIQXXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 19:23:35 -0400
Date: Thu, 18 Sep 2014 09:23:22 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] KEYS: Fixes for keyrings
In-Reply-To: <24647.1410876063@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.11.1409180922540.31048@namei.org>
References: <23655.1410874187@warthog.procyon.org.uk> <24647.1410876063@warthog.procyon.org.uk>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2014, David Howells wrote:

> > Can you please pull these fixes and send them on upstream:
> 
> Can you also pull them into your next branch as I have stuff for your next
> branch that depends on those changes?

No, if they go direct to Linus, they don't go into -next.


-- 
James Morris
<jmorris@namei.org>

