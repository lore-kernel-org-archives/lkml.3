Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436AbaGUSd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 14:33:27 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:63857 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933219AbaGUSd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 14:33:26 -0400
Date: Mon, 21 Jul 2014 14:33:22 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        IDE-ML <linux-ide@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: [GIT PULL] libata fixes for v3.16-rc6
Message-ID: <20140721183322.GA29601@mtj.dyndns.org>
References: <20140721121740.GB12921@htj.dyndns.org>
 <CA+55aFwzZoef-fXj1D57N9ywxWBF0bj2cWgOQMQDLM=NAH7hrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwzZoef-fXj1D57N9ywxWBF0bj2cWgOQMQDLM=NAH7hrA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

On Mon, Jul 21, 2014 at 11:27:18AM -0700, Linus Torvalds wrote:
> On Mon, Jul 21, 2014 at 5:17 AM, Tejun Heo <tj@kernel.org> wrote:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git
> >
> > for you to fetch changes up to b32bfc06aefab61acc872dec3222624e6cd867ed:
> 
> Nope, nothing like that there.
> 
> Did you perhaps mean for me to pull the "for-3.16-fixes" branch?
> Because that does indeed match what you are speaking of...
> 
> I pulled the correct branch, but please, please, *please* fix your
> scripts to have the right branch name.

Urgh... sorry about that.  This is the same git-request-pull problem
that occurred the last time.  I forgot adding cc:stable to the last
patch and force-pushed that out before generating the pull request (I
had it sitting in my local branch for some days) and git-request-pull
dropped the branch name because the commit IDs of local and remote
disagreed.  git --version says 1.9.3.  Maybe it's not fixed in this
version yet?

Thanks.

-- 
tejun
