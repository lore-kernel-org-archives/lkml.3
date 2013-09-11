Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab3IKPlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:41:31 -0400
Received: from tundra.namei.org ([65.99.196.166]:51097 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367Ab3IKPl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:41:29 -0400
Date: Thu, 12 Sep 2013 01:41:42 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: simo@redhat.com, zohar@linux.vnet.ibm.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Keyrings patches
In-Reply-To: <10114.1378806359@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.02.1309120141280.4317@tundra.namei.org>
References: <alpine.LRH.2.02.1309071426400.29124@tundra.namei.org> <alpine.LRH.2.02.1309070309360.24160@tundra.namei.org> <12075.1378340063@warthog.procyon.org.uk> <17000.1378488989@warthog.procyon.org.uk> <10114.1378806359@warthog.procyon.org.uk>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Sep 2013, David Howells wrote:

> James Morris <jmorris@namei.org> wrote:
> 
> > > > This missed the merge for 3.12.  Do you want me to queue the changes up, 
> > > > or do you want to send a pull request again after -rc1 ?
> > > 
> > > Can you queue them up now in your 'next' branch?
> > 
> > Nope, new patches can't go into -next until -rc1.
> 
> I think I misunderstood your offer.  When you said "to queue the changes up"
> did you mean for immediate passage to Linus?  If so, is it too late for that?

Nope, I meant for -next :)


-- 
James Morris
<jmorris@namei.org>
