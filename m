Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab3B1ITb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:19:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab3B1IT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:19:29 -0500
Message-ID: <512F130C.5020002@suse.cz>
Date: Thu, 28 Feb 2013 09:19:24 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Josh Boyer <jwboyer@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowell@redhat.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 3/3] convert headers_install.pl to headers_install.sh
References: <1361944667.959170@landley.net>
In-Reply-To: <1361944667.959170@landley.net>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.2.2013 06:58, Rob Landley wrote:
> From: Rob Landley <rob@landley.net>
> 
> Remove perl from make headers_install by replacing a perl script (doing
> a simple regex search and replace) with a smaller, faster, simpler,
> POSIX-2008 shell script implementation.  The new shell script is a single
> for loop calling sed and piping its output through unifdef to produce the
> target file.
> 
> Same as last time except for minor tweak to deal with code review from here:
> http://lkml.indiana.edu/hypermail/linux/kernel/1302.3/00078.html
> 
> (Note that this drops the "arch" argument, which isn't used. Kbuild
> already points to the right input files on the command line.)
> 
> Signed-off-by: Rob Landley <rob@landley.net>

Looks good, I will apply it after v3.9-rc1 is out.

Michal
