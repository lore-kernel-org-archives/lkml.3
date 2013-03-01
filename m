Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab3CAFH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 00:07:56 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:56611 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab3CAFHy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 00:07:54 -0500
Date: Thu, 28 Feb 2013 23:07:49 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 3/3] convert headers_install.pl to headers_install.sh
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Josh Boyer <jwboyer@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowell@redhat.com>, Sam Ravnborg <sam@ravnborg.org>
References: <1361944667.959170@landley.net> <512F130C.5020002@suse.cz>
In-Reply-To: <512F130C.5020002@suse.cz> (from mmarek@suse.cz on Thu Feb 28
	02:19:24 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1362114469.21837.0@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 02:19:24 AM, Michal Marek wrote:
> On 27.2.2013 06:58, Rob Landley wrote:
> > From: Rob Landley <rob@landley.net>
> >
> > Remove perl from make headers_install by replacing a perl script  
> (doing
> > a simple regex search and replace) with a smaller, faster, simpler,
> > POSIX-2008 shell script implementation.  The new shell script is a  
> single
> > for loop calling sed and piping its output through unifdef to  
> produce the
> > target file.
> >
> > Same as last time except for minor tweak to deal with code review  
> from here:
> > http://lkml.indiana.edu/hypermail/linux/kernel/1302.3/00078.html
> >
> > (Note that this drops the "arch" argument, which isn't used. Kbuild
> > already points to the right input files on the command line.)
> >
> > Signed-off-by: Rob Landley <rob@landley.net>
> 
> Looks good, I will apply it after v3.9-rc1 is out.

Yay! Thank you!

(Andrew took the other two! Thank you!)

Rob
