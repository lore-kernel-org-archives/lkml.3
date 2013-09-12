Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab3ILV0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 17:26:42 -0400
Received: from mail.nt1.in ([62.90.139.210]:41799 "EHLO mail.nt1.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab3ILV0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 17:26:41 -0400
Date: Fri, 13 Sep 2013 00:26:36 +0300
From: Regid Ichira <regid23@nt1.in>
To: Rob Landley <rob@landley.net>
Cc: "Steven Mr. Procrastinator Rostedt" <rostedt@goodmis.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] README: Alternative configuration commands does not
 mention make listnewconfig
Message-ID: <20130912212636.GH8821@nt1.in>
References: <20130912003919.GG8821@nt1.in>
 <1378973880.1974.11@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378973880.1974.11@driftwood>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 03:18:00AM -0500, Rob Landley wrote:
> On 09/11/2013 07:39:19 PM, Regid Ichira wrote:
> >Applied to the tip of linux.git,
> >                      VERSION = 3 PATCHLEVEL = 11 SUBLEVEL = 0
> >Signed-off-by: Regid Ichira <regid23@nt1.in>
> >---
> > README | 4 ++++
> > 1 file changed, 4 insertions(+)
> >
> >diff --git a/README b/README
> >index a24ec89..f10c16f 100644
> >--- a/README
> >+++ b/README
> >@@ -228,6 +228,10 @@ CONFIGURING the kernel:
> >      "make localyesconfig" Similar to localmodconfig, except it
> >will convert
> >                            all module options to built in (=y)
> >options.
> >
> >+     "make listnewconfig"  Based on the contents of your existing
> >./.config
> >+                        file, print all the new config symbols.
> >One at a
> >+                        line.
> >+
> >    You can find more information on using the Linux kernel config
> >tools
> >    in Documentation/kbuild/kconfig.txt.
> 
> "make help" does, though. Possibly the README should point people at
> that instead of trying to keep a (third?) copy of this info in sync?
> 
> Rob


1) If make help is the second copy of this info, and the README is
   the third, where is the first, master, copy?
2) Doesn't the README have slightly more information on each option
   than make help, or that the README info is somewhat better to
   beginners?  Perhaps the README entries should first be combined
   into make help?
