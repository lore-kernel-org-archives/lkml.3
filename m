Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab3DKQZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:25:17 -0400
Received: from mail-ia0-f179.google.com ([209.85.210.179]:58759 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab3DKQZP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:25:15 -0400
Date: Thu, 11 Apr 2013 11:25:10 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 3/3] convert headers_install.pl to headers_install.sh
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Josh Boyer <jwboyer@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowell@redhat.com>, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <5163F2F0.1070405@suse.cz> (from mmarek@suse.cz on Tue Apr  9
	05:52:32 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1365697510.18069.78@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 05:52:32 AM, Michal Marek wrote:
> On 28.2.2013 09:19, Michal Marek wrote:
> > On 27.2.2013 06:58, Rob Landley wrote:
> >> From: Rob Landley <rob@landley.net>
> >>
> >> Remove perl from make headers_install by replacing a perl script  
> (doing
> >> a simple regex search and replace) with a smaller, faster, simpler,
> >> POSIX-2008 shell script implementation.  The new shell script is a  
> single
> >> for loop calling sed and piping its output through unifdef to  
> produce the
> >> target file.
> >>
> >> Same as last time except for minor tweak to deal with code review  
> from here:
> >> http://lkml.indiana.edu/hypermail/linux/kernel/1302.3/00078.html
> >>
> >> (Note that this drops the "arch" argument, which isn't used. Kbuild
> >> already points to the right input files on the command line.)
> >>
> >> Signed-off-by: Rob Landley <rob@landley.net>
> >
> > Looks good, I will apply it after v3.9-rc1 is out.
> 
> I forgot to do it right after rc1, but I took the patch from the mm  
> tree
> now. I also added Sam's Ack from the earlier submission.
> 
> Michal

Yay!

Is this for 3.10? (Not seeing it in Linus's tree now, and -rc7 seems a  
bit late for anything to go in...)

Thanks,

Rob