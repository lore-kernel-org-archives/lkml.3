Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab3KYMDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 07:03:21 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:40799 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab3KYMDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 07:03:18 -0500
Message-ID: <1385380993.2398.25.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [GIT PULL] ima: bug fixes for Linus
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 25 Nov 2013 07:03:13 -0500
In-Reply-To: <alpine.LRH.2.02.1311251313290.2899@tundra.namei.org>
References: <1385145621.9559.5.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <1385306510.5186.7.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <alpine.LRH.2.02.1311250943500.2259@tundra.namei.org>
	 <1385338461.5402.3.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <alpine.LRH.2.02.1311251313290.2899@tundra.namei.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112512-0928-0000-0000-000004011F59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-25 at 13:14 +1100, James Morris wrote:
> On Sun, 24 Nov 2013, Mimi Zohar wrote:
> 
> > On Mon, 2013-11-25 at 09:44 +1100, James Morris wrote:
> > > On Sun, 24 Nov 2013, Mimi Zohar wrote:
> > > 
> > > > Hi James,
> > > > 
> > > > Linus has already reverted the trusted keyring support for IMA patches.
> > > > These patches are re-based on -rc1.
> > > > 
> > > > The following changes since commit 4c1cc40a2d49500d84038ff751bc6cd183e729b5:
> > > > 
> > > >   Revert "KEYS: verify a certificate is signed by a 'trusted' key" (2013-11-23 16:38:17 -0800)
> > > > 
> > > > are available in the git repository at:
> > > > 
> > > >   git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity for-linus
> > > > 
> > > > for you to fetch changes up to 3eeb2d63ab623be55bb2ff584e123c0df45691e3:
> > > > 
> > > >   ima: make a copy of template_fmt in template_desc_init_fields() (2013-11-24 00:29:23 -0500)
> > > > 
> > > 
> > > I don't understand -- are these all fixes for regressions in the new 
> > > kernel?
> > 
> > Yes, mostly.  There's one code cleanup, that could be deferred and a
> > documentation update.
> 
> Can we leave documentation and code cleanups to the next cycle and only 
> include essential fixes for regressions at this stage?

Ok, all of the patches are needed and need to be upstreamed.  I assume
all of the ones that fix backwards compatibility issues would be termed
"essential fixes for regressions".

47a20c2 ima: do not include field length in template digest calc for ima templat
4c8f4bb ima: do not send field length to userspace for digest of ima template
3eeb2d6 ima: make a copy of template_fmt in template_desc_init_fields()

Could the remaining patches be marked for -stable?

> Also, please identify which upstream commits specifically are fixed by 
> each patch.

Ok

thanks,

Mimi

