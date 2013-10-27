Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab3J0Qbd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 12:31:33 -0400
Received: from psi.thgersdorf.net ([176.9.98.78]:52817 "EHLO mail.psioc.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277Ab3J0Qbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 12:31:31 -0400
From: Thomas Rast <tr@thomasrast.ch>
To: Stefan Beller <stefanbeller@googlemail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Michael Haggerty <mhagger@alum.mit.edu>, git@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>, Greg KH <greg@kroah.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        ksummit-attendees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] commit: Add -f, --fixes <commit> option to add Fixes: line
References: <20131024122255.GI9378@mwanda> <20131024122512.GB9534@mwanda>
	<20131026181709.GB10488@kroah.com> <20131027013402.GA7146@leaf>
	<526CA7D4.1070904@alum.mit.edu> <20131027071407.GA11683@leaf>
	<874n83m8xv.fsf@linux-k42r.v.cablecom.net>
	<526CDC5C.40208@googlemail.com>
Date: Sun, 27 Oct 2013 17:30:42 +0100
In-Reply-To: <526CDC5C.40208@googlemail.com> (Stefan Beller's message of "Sun,
	27 Oct 2013 10:26:52 +0100")
Message-ID: <87zjpuznf1.fsf@thomasrast.ch>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Beller <stefanbeller@googlemail.com> writes:

> I assembled an overview table, which plots the long options of 
> git commands by the short letters.
[...]
> (In case thunderbird messes it up, here it is again http://pastebin.com/raw.php?i=JBci2Krx)
>
> As you can see, f is always --force except for git-config, where it is --file

Woah!  Impressive work.  Did you autogenerate this?  If so, can we have
it as a small make target somewhere?  If not, can you send a patch to
put your table in Documentation somewhere?

-- 
Thomas Rast
tr@thomasrast.ch
