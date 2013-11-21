Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab3KUWw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 17:52:26 -0500
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:45312
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753041Ab3KUWwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 17:52:23 -0500
Date: Thu, 21 Nov 2013 22:52:21 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Aditya Kali <adityakali@google.com>,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: Fix namespace mountpoint path in /proc/mounts
Message-ID: <20131121225221.GA10445@mail.hallyn.com>
References: <1382737870-12792-1-git-send-email-adityakali@google.com>
 <20131029153610.GB32008@mail.hallyn.com>
 <87a9heqwkg.fsf@xmission.com>
 <20131121215035.GA9773@mail.hallyn.com>
 <87r4a974rb.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r4a974rb.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serge@hallyn.com> writes:
> 
> > Aditya, is this something you'd have time to write a patch for?
> 
> I have a tested patch that fixes when we call ns_dname.  Give me a day
> and I will push out my pending pile of fixes for review.
> 
> Eric

Oh, awesome, thanks!

-serge
