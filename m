Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbaIRNn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 09:43:29 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:41174 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbaIRNn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 09:43:26 -0400
Message-ID: <1411047801.2076.21.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [Keyrings] [GIT PULL] KEYS: Fixes for keyrings
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 18 Sep 2014 09:43:21 -0400
In-Reply-To: <20016.1411046628@warthog.procyon.org.uk>
References: <alpine.LRH.2.11.1409181712020.1998@namei.org>
	 <alpine.LRH.2.11.1409180922540.31048@namei.org>
	 <23655.1410874187@warthog.procyon.org.uk>
	 <24647.1410876063@warthog.procyon.org.uk>
	 <2171.1410996444@warthog.procyon.org.uk>
	 <20016.1411046628@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091813-7164-0000-0000-000004B50BB1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-18 at 14:23 +0100, David Howells wrote: 
> James Morris <jmorris@namei.org> wrote:
> 
> > > > No, if they go direct to Linus, they don't go into -next.
> > > 
> > > Can you then sync your -next branch to Linus after Linus takes them please?
> > 
> > Nope, I only want to sync on point releases unless absolutely necessary.
> 
> In that case, can you please just pull the request in this message that I sent
> you:
> 
> 	[GIT PULL] KEYS: Changes for keyrings for security/next
> 
> It has the aforementioned fixes and the stuff for -next both.  If you can just
> pull the lot into your -next branch rather than sending the fixes upstream at
> this point.

David, consider copying stable to automatically have bug fixes
backported.  After your "signed-off-by" add "Cc:
<stable@vger.kernel.org>  <release>" to indicate which kernel release.

Mimi

