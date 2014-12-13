Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbaLMWcO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 17:32:14 -0500
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:44964
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbaLMWcL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 17:32:11 -0500
In-Reply-To: <20141210224822.GG20012@ubuntumail>
References: <CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com>
 <87h9x5re41.fsf_-_@x220.int.ebiederm.org>
 <87mw6xpzb0.fsf_-_@x220.int.ebiederm.org>
 <CALCETrU-o5mPr1jCaLXDuuF6J2N470zAtx=8Fa-SjF=ZpdE8mQ@mail.gmail.com>
 <87ppbtn4mv.fsf@x220.int.ebiederm.org>
 <CALCETrXSScp77BUJR5NSTh5-RnEZ9rqELSGJBeEzgdQ-OtohuQ@mail.gmail.com>
 <87a92xn2io.fsf@x220.int.ebiederm.org>
 <87r3w8liw4.fsf@x220.int.ebiederm.org>
 <87iohklfvj.fsf_-_@x220.int.ebiederm.org>
 <87mw6vh31e.fsf_-_@x220.int.ebiederm.org> <20141210224822.GG20012@ubuntumail>
From: serge@hallyn.com
Subject: Re: [CFT] Can I get some Tested-By's on this series?
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: "Andy Lutomirski" <luto@amacapital.net>,
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
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Sat, 13 Dec 2014 22:31:59 +0000
Message-ID: <ck3e3r.ngjl9i.670r4b-qmf@mail.hallyn.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sorry, I've only been back from the road the days...  Two tries at compiling have failed (infrastructure problems, not your set), hoping to fire of another build tonight.On 12/10/14 16:48 Serge Hallyn wrote:
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

