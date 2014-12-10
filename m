Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933435AbaLJWse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 17:48:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39715 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933041AbaLJWsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 17:48:30 -0500
Date: Wed, 10 Dec 2014 22:48:22 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Richard Weinberger <richard@nod.at>,
        linux-man <linux-man@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>, stable <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kenton Varda <kenton@sandstorm.io>,
        LSM <linux-security-module@vger.kernel.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [CFT] Can I get some Tested-By's on this series?
Message-ID: <20141210224822.GG20012@ubuntumail>
References: <CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com>
 <87h9x5re41.fsf_-_@x220.int.ebiederm.org>
 <87mw6xpzb0.fsf_-_@x220.int.ebiederm.org>
 <CALCETrU-o5mPr1jCaLXDuuF6J2N470zAtx=8Fa-SjF=ZpdE8mQ@mail.gmail.com>
 <87ppbtn4mv.fsf@x220.int.ebiederm.org>
 <CALCETrXSScp77BUJR5NSTh5-RnEZ9rqELSGJBeEzgdQ-OtohuQ@mail.gmail.com>
 <87a92xn2io.fsf@x220.int.ebiederm.org>
 <87r3w8liw4.fsf@x220.int.ebiederm.org>
 <87iohklfvj.fsf_-_@x220.int.ebiederm.org>
 <87mw6vh31e.fsf_-_@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mw6vh31e.fsf_-_@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> 
> Will people please test these patches with their container project?
> 
> These changes break container userspace (hopefully in a minimal way) if
> I could have that confirmed by testing I would really appreciate it.  I
> really don't want to send out a bug fix that accidentally breaks
> userspace again.
> 
> The only issue sort of under discussion is if there is a better name for
> /proc/<pid>/setgroups, and the name of the file will not affect the
> functionality of the patchset.
> 
> With the code reviewed and written in simple obviously correct, easily
> reviewable ways I am hoping/planning to send this to Linus ASAP.
> 
> Eric

Is there a git tree we can clone?
