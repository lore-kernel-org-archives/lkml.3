Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaCGQGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 11:06:41 -0500
Received: from www84.your-server.de ([213.133.104.84]:49662 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbaCGQGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 11:06:38 -0500
Message-ID: <1394208388.1012.2.camel@wall-e.seibold.net>
Subject: Re: [x86, vdso]  BUG: unable to handle kernel paging request at
 d34bd000
From: Stefani Seibold <stefani@seibold.net>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Fri, 07 Mar 2014 17:06:28 +0100
In-Reply-To: <20140307102107.GA21656@localhost>
References: <20140307013833.GD8427@localhost>
	 <1394182034.21684.6.camel@wall-e.seibold.net>
	 <20140307091515.GA8888@localhost>
	 <1394186248.28066.42.camel@wall-e.seibold.net>
	 <20140307102107.GA21656@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 07.03.2014, 18:21 +0800 schrieb Fengguang Wu:
> Hi Stefani,
> 
> On Fri, Mar 07, 2014 at 10:57:28AM +0100, Stefani Seibold wrote:
> > Hi Fengguang,
> > 
> > did you test the config i had sent to you?
> > 
> > My test was all done with current 3.14-rc tree. And with this i have no
> > problem. 
> 
> The regression is found on commit 4dea8e4824b363c53f320d328040d7c6c5921419
> ("x86, vdso: Add 32 bit VDSO time support for 32 bit kernel") in tip tree.
> 
> In the bisect log, you can see that next-20140306 is GOOD. So there's
> no way you can find the bug in 3.14-rcX.
> 
> > I just cloned the tip tree and i figured out that the patch was dropped
> > again (BTW: git log does not show that it was ever applied).
> 
> You can still access that specific commit:
> 
> wfg@bee /tmp% git clone --reference /c/linux git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git

As i wrote i already cloned the tip tree!!!!!!

But i cannot see the changeset, there is also no VDSO changes set in the
git log.



