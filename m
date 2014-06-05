Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbaFEWj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 18:39:27 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:38619 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbaFEWjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 18:39:13 -0400
From: Paul Moore <paul@paul-moore.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        "Serge E. Hallyn" <serge@canonical.com>
Subject: Re: Change in security maintainer for a few weeks
Date: Thu, 05 Jun 2014 18:39:09 -0400
Message-ID: <4426926.gIRHbeKnmD@sifl>
User-Agent: KMail/4.13.1 (Linux/3.14.4-gentoo; KDE/4.13.1; x86_64; ; )
In-Reply-To: <alpine.LRH.2.00.1406052355500.2434@twin.jikos.cz>
References: <20140605183050.GA5054@kroah.com> <alpine.LRH.2.00.1406052355500.2434@twin.jikos.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 05, 2014 11:59:11 PM Jiri Kosina wrote:
> On Thu, 5 Jun 2014, Greg KH wrote:
> > James has had to step back from doing kernel work for a few weeks, so
> > I've offered to step up and handle the security patches to get shuttled
> > to Linus for merging for a while.
> 
> As exactly this (working with active contributors to help co-maintain the
> subsystem) has been brought at the ksummit maling list, I am just curious
> whether noone else actively working in that area was willing to step up?
> 
> 	$ ./scripts/get_maintainer.pl --git -f security/
> 	James Morris <james.l.morris@oracle.com> (supporter:SECURITY SUBSYSTEM)
>    ...
> 
> If not, then I think this can be shown as a prime example why the problem
> of "non-substituability" of many maintainers is actually real.

Once several of us became aware that James was stepping away for a few weeks 
(I should mention this was not a planned absence and took most of us by 
surprise) we had a brief discussion off-list and several of us did offer to 
"step-up"; Serge had already created a repo and since he had pushed patches 
while James was away in the past it seemed a reasonable approach this time 
around.

-- 
paul moore
www.paul-moore.com

