Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab3EXEKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 00:10:30 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:48863 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3EXEK2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 00:10:28 -0400
Date: Thu, 23 May 2013 23:10:24 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 1/8] Documentation: Adding "The Perfect Patch" by Andrew
 Morton
To: Ben Minerds <puzzleduck@gmail.com>
Cc: greg@kroah.com, Ben Minerds <PuZZleDucK@gmail.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <5114385ce1897015ad96f59f0fd46014d5f07786.1369312746.git.PuZZleDucK@gmail.com>
	(from puzzleduck@gmail.com on Thu May 23 07:49:53 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1369368624.2776.13@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2013 07:49:53 AM, Ben Minerds wrote:
>  Adding Andrews advice on patch submission and subdirectory for  
> further patch
>  documentstion.

You've seen Documentation/SubmittingPatches right?

>  Signed-off-by: Ben Minerds <puzzleduck@gmail.com>
> ---
>  .../patches/The-Perfect-Patch.txt                  | 167  
> +++++++++++++++++++++
>  1 file changed, 167 insertions(+)
>  create mode 100644  
> Documentation/development-process/patches/The-Perfect-Patch.txt
> 
> diff --git  
> a/Documentation/development-process/patches/The-Perfect-Patch.txt  
> b/Documentation/development-process/patches/The-Perfect-Patch.txt
> new file mode 100644
> index 0000000..b07074e
> --- /dev/null
> +++ b/Documentation/development-process/patches/The-Perfect-Patch.txt
> @@ -0,0 +1,167 @@
> +From: Andrew Morton [email blocked]
> +To: Mukker, Atul [email blocked]
> +Subject: Re: [patch] 2.6.9-rc1-mm1: megaraid_mbox.c compile error  
> with gcc 3.4
> +Date: 	Sat, 28 Aug 2004 13:04:19 -0700
> +

This email is eight years old.

> +"Mukker, Atul" [email blocked] wrote:
> +>
> +> The driver and the patches with the re-ordered functions is  
> available at
> +>  ftp://ftp.lsil.com/pub/linux-megaraid/drivers/version-2.20.3.1/
> +
> +I dunno about James, but I *really* dislike receiving patches by  
> going and
> +getting them from internet servers.  It breaks our commonly-used  
> tools.  It
> +loses authorship info.  It loses Signed-off-by: info.  There is no
> +changelog.  All this means that your patch is more likely to be  
> ignored by
> +busy people.  Please, just email the diffs.
> +
> +I wrote a little guide this week:
> +
> +
> +
> +The perfect patch. [email blocked]
> +
> +The latest version of this document may be found at
> +http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt

Could you just grab the actual version from his repo instead of one  
that says "email blocked" and commemorates the URL of a rejected  
submission in a chatty email header?

> +Delivery
> +========
> +
> +- Patches are delivered via email only.  Downloading them from  
> internet
> +  servers is a pain.
> +
> +- One patch per email, with the changelog in the body of the email.
> +
> +Subject:
> +========
> +
> +- The email's Subject: should consisely describe the patch which  
> that email
> +  contains.  The Subject: should not be a filename.  Do not use the  
> same
> +  Subject: for every patch in a whole patch series.
> +
> +  Bear in mind that the Subject: of your email becomes a  
> globally-unique
> +  identifier for that patch.  It propagates all the way into  
> BitKeeper.  The
> +  Subject: may later be used in developer discussions which refer to  
> the
> +  patch.  People will want to google for the patch's Subject: to read
> +  discussion regarding that patch.
> +
> +- When sending a series of patches, the patches should be  
> sequence-numbered
> +  in the Subject:
> +
> +- It is nice if the Subject: includes mention of the subsystem which  
> it
> +  affects.  See example below.
> +
> +- Example Subject:
> +
> +	[patch 2/5] ext2: improve scalability of bitmap searching
> +
> +- Note that various people's patch receiving scripts will strip away
> +  Subject: text which is inside brackets [].  So you should place  
> information
> +  which has no long-term relevance to the patch inside brackets.   
> This
> +  includes the word "patch" and any sequence numbering.  The  
> subsystem
> +  identifier ("ext2:") should hence be outside brackets.
> +
> +
> +Changelog
> +=========
> +
> +- Bear in mind that the Subject: and changelog which you provide will
> +  propagate all the way into the permanent kernel record.  Other  
> developers
> +  will want to read and understand your patch and changelog years in  
> the
> +  future.
> +
> +  So the changelog should describe the patch fully:
> +
> +  - why the kernel needed patching
> +
> +  - the overall design approach in the patch
> +
> +  - implementation details
> +
> +  - testing results
> +
> +- Don't bother mentioning what version of the kernel the patch  
> applies to
> +  ("applies to 2.6.8-rc1").  This is not interesting information -  
> once the
> +  patch is in bitkeeper, of _course_ it applied, and it'll probably  
> be merged
> +  into a later kernel than the one which you wrote it for.
> +

Bitkeeper?

Is this really current advice? What part of this has _not_ been put in  
SubmittingPatches yet?

(I'm all for moving SubmittingPatches and friends under  
development-process/ and in fact vaguely plan a general Documentation/  
tree cleanup next time I have some downtime between contracts. But  
adding eight year old duplication: not so much.)

> +- Do not refer to earlier patches when changelogging a new version  
> of a
> +  patch.  It's not very useful to have a bitkeeper changelog which  
> says "OK,
> +  this fixes the things you mentioned yesterday".  Each iteration of  
> the patch
> +  should contain a standalone changelog.  This implies that you need  
> a patch
> +  management system which maintains changelogs.  See below.
> +
> +- Add a Signed-off-by: line.
> +

There's a whole edifice of signed-off-by line advice elsewhere in  
Documentation. (The pointy-haired types descended on this and attempted  
to make a bureaucracy out of it.)

> +- Most people's patch receiving scripts will treat a ^--- string as  
> the
> +  separator between the changelog and the patch itself.  You can use  
> this to
> +  ensure that any diffstat information is discarded when the patch  
> is applied:
> +
> +
> +
> +	Another few #if/#ifdef cleanups, this time for the PPC  
> architecture.
> +
> +	Signed-off-by: <valdis.kletnieks@vt.edu>
> +	Signed-off-by: Andrew Morton [email blocked]
> +	---
> +
> +	 25-akpm/arch/ppc/kernel/process.c                    |    2 +-
> +	 25-akpm/arch/ppc/platforms/85xx/mpc85xx_cds_common.c |    2 +-
> +	 25-akpm/arch/ppc/syslib/ppc85xx_setup.c              |    4  
> ++--
> +	 3 files changed, 4 insertions(+), 4 deletions(-)
> +
> +	--- 25/arch/ppc/kernel/process.c
> +	+++ 25/arch/ppc/kernel/process.c
> +	@@ -667,7 +667,7 @@ void show_stack(struct task_struct *tsk,
> +

SubmittingPatches has recommended diffstat command lines...

> +
> +The diff
> +========
> +
> +- Patches should be in `patch -p1' form:
> +
> +  --- a/kernel/sched.c
> +  +++ b/kernel/sched.c
> +
> +- Make sure that your patches apply to the latest version of the  
> kernel
> +  tree.  Either straight from bitkeeper or from
> +  ftp://ftp.kernel.org/pub/linux/kernel/v2.6/snapshots/
> +
> +- When raising patches for -mm it's generally best to base them on  
> the
> +  latest Linus tree.  I'll work out any rejects/incompatibilities.   
> There are
> +  of course exceptions to this.
> +
> +- Ensure that your patch does not add new trailing whitespace.  The  
> below
> +  script will fix up your patch by stripping off such whitespace.
> +
> +	#!/bin/sh
> +
> +	strip1()
> +	{
> +		TMP=$(mktemp /tmp/XXXXXX)
> +		cp $1 $TMP
> +		sed -e '/^+/s/[ 	]*$//' < $TMP > $1
> +		rm $TMP
> +	}
> +
> +	for i in $*
> +	do
> +		strip1 $i
> +	done

Doesn't scripts/checkpatch.pl check for this?

> +
> +Overall
> +=======
> +
> +- Avoid MIME and attachements if possible.  Make sure that your  
> email client
> +  does not wordwrap your patch.  Make sure that your email client  
> does not
> +  replace tabs with spaces.

We have Docuemntation/email-clients.txt which would probably also go  
under development-process/.

Rob