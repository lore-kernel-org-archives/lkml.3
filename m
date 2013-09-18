Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab3IRMsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:48:07 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54062 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759Ab3IRMsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:48:03 -0400
Message-ID: <1379508476.8819.40.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [GIT PULL] Keyrings patches
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, James Morris <jmorris@namei.org>,
        simo@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 18 Sep 2013 08:47:56 -0400
In-Reply-To: <1320.1379505186@warthog.procyon.org.uk>
References: <20130918115000.b78a5e79d65aa23ced0ac8e4@canb.auug.org.au>
	 <alpine.LRH.2.02.1309120141280.4317@tundra.namei.org>
	 <alpine.LRH.2.02.1309071426400.29124@tundra.namei.org>
	 <alpine.LRH.2.02.1309070309360.24160@tundra.namei.org>
	 <12075.1378340063@warthog.procyon.org.uk>
	 <17000.1378488989@warthog.procyon.org.uk>
	 <10114.1378806359@warthog.procyon.org.uk>
	 <19686.1379426149@warthog.procyon.org.uk>
	 <1320.1379505186@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091812-7182-0000-0000-00000871D19E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-18 at 12:53 +0100, David Howells wrote:
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Is there some reason that those fixups cannot be done in a merge commit?
> > i.e. are they more than simple text updates?

Hi Stephen, the issue is that the patches were created against a newer
kernel (eg. next, akpm, Linus' branch), not the earlier one.  So it
isn't a merge issue per se.  Now that -rc1 is out, James will rebase
soon.

Mimi

> That's somewhat up to James.  *He* would be the person doing the merge, not
> me.  I'm changing the lines in my patches also.
> 
> > /me thinks that most rebases people do can be better done (and
> > documented) as merges.
> 
> That depends on how you define "better".  Better for what?  I think it's
> better to absorb the changes into my patch series.  StGIT is very good for
> handling this, since my patches are currently maintained as an StGIT set.
> That way, there ends up one fewer commit in the history, assuming no other
> collisions with what James merges.
> 
> David



