Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750840Ab3IGEZO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 00:25:14 -0400
Received: from tundra.namei.org ([65.99.196.166]:60384 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787Ab3IGEZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 00:25:12 -0400
Date: Sat, 7 Sep 2013 14:26:57 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: simo@redhat.com, zohar@linux.vnet.ibm.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Keyrings patches
In-Reply-To: <17000.1378488989@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.02.1309071426400.29124@tundra.namei.org>
References: <alpine.LRH.2.02.1309070309360.24160@tundra.namei.org> <12075.1378340063@warthog.procyon.org.uk> <17000.1378488989@warthog.procyon.org.uk>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Sep 2013, David Howells wrote:

> James Morris <jmorris@namei.org> wrote:
> 
> > > Could you pull these patches into the security tree?  They're based on your
> > > next branch.
> > 
> > This missed the merge for 3.12.  Do you want me to queue the changes up, 
> > or do you want to send a pull request again after -rc1 ?
> 
> Can you queue them up now in your 'next' branch?

Nope, new patches can't go into -next until -rc1.


-- 
James Morris
<jmorris@namei.org>
