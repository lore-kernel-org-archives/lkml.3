Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaFEV7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 17:59:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbaFEV7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 17:59:17 -0400
Date: Thu, 5 Jun 2014 23:59:11 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Greg KH <gregkh@linuxfoundation.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: Change in security maintainer for a few weeks
In-Reply-To: <20140605183050.GA5054@kroah.com>
Message-ID: <alpine.LRH.2.00.1406052355500.2434@twin.jikos.cz>
References: <20140605183050.GA5054@kroah.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2014, Greg KH wrote:

> James has had to step back from doing kernel work for a few weeks, so
> I've offered to step up and handle the security patches to get shuttled
> to Linus for merging for a while.

As exactly this (working with active contributors to help co-maintain the 
subsystem) has been brought at the ksummit maling list, I am just curious 
whether noone else actively working in that area was willing to step up?

	$ ./scripts/get_maintainer.pl --git -f security/
	James Morris <james.l.morris@oracle.com> (supporter:SECURITY SUBSYSTEM)
	Mimi Zohar <zohar@linux.vnet.ibm.com> (commit_signer:51/220=23%)
	Paul Moore <pmoore@redhat.com> (commit_signer:43/220=20%,authored:24/220=11%)
	Eric Paris <eparis@redhat.com> (commit_signer:43/220=20%,authored:16/220=7%)
	David Howells <dhowells@redhat.com> (commit_signer:29/220=13%,authored:24/220=11%)
	Roberto Sassu <roberto.sassu@polito.it> (commit_signer:24/220=11%,authored:19/220=9%)
	John Johansen <john.johansen@canonical.com> (authored:20/220=9%)

If not, then I think this can be shown as a prime example why the problem 
of "non-substituability" of many maintainers is actually real.

Thanks,

-- 
Jiri Kosina
SUSE Labs

