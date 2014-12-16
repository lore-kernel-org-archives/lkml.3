Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750936AbaLPJXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 04:23:38 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65278 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbaLPJXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 04:23:34 -0500
Message-ID: <548FFA0D.7060008@nod.at>
Date: Tue, 16 Dec 2014 10:23:25 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC: "Serge E. Hallyn" <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Kenton Varda <kenton@sandstorm.io>, stable <stable@vger.kernel.org>
Subject: Re: [CFT] Can I get some Tested-By's on this series?
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net> <87fvcxyf28.fsf_-_@x220.int.ebiederm.org> <874mtdyexp.fsf_-_@x220.int.ebiederm.org> <CALCETrXyC7XPaqj6oe-TmyypOVc_CkZbF6UAAx8YfkyD=gEMOQ@mail.gmail.com> <87a935u3nj.fsf@x220.int.ebiederm.org> <CALCETrXkEOiyzpvqtXtk1f4sL+M1Q-Y6rV=K91ez3yv2nb4Y0Q@mail.gmail.com> <87388xodlj.fsf@x220.int.ebiederm.org> <CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com> <87h9x5re41.fsf_-_@x220.int.ebiederm.org> <87mw6xpzb0.fsf_-_@x220.int.ebiederm.org> <CALCETrU-o5mPr1jCaLXDuuF6J2N470zAtx=8Fa-SjF=ZpdE8mQ@mail.gmail.com> <87ppbtn4mv.fsf@x220.int.ebiederm.org> <CALCETrXSScp77BUJR5NSTh5-RnEZ9rqELSGJBeEzgdQ-OtohuQ@mail.gmail.com> <87a92xn2io.fsf@x220.int.ebiederm.org> <87r3w8liw4.fsf@x220.int.ebiederm.org> <87iohklfvj.fsf_-_@x220.int.ebiederm.org> <87mw6vh31e.fsf_-_@x220.int.ebiederm.org> <CALCETrWXp3eq2O068NZcd+KPCg+N2y0T57Q0JzHcZLjzq+mXLA@mail.gmail.com>
In-Reply-To: <CALCETrWXp3eq2O068NZcd+KPCg+N2y0T57Q0JzHcZLjzq+mXLA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.12.2014 um 03:05 schrieb Andy Lutomirski:
> On Wed, Dec 10, 2014 at 8:39 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> Will people please test these patches with their container project?
>>
>> These changes break container userspace (hopefully in a minimal way) if
>> I could have that confirmed by testing I would really appreciate it.  I
>> really don't want to send out a bug fix that accidentally breaks
>> userspace again.
>>
>> The only issue sort of under discussion is if there is a better name for
>> /proc/<pid>/setgroups, and the name of the file will not affect the
>> functionality of the patchset.
>>
>> With the code reviewed and written in simple obviously correct, easily
>> reviewable ways I am hoping/planning to send this to Linus ASAP.
> 
> 
> I tested this with Sandstorm.  It breaks as is and it works if I add
> the setgroups thing.
> 
> Tested-by: Andy Lutomirski <luto@amacapital.net> # breaks things as designed :(
> 
> I still don't like the name "setgroups".

I agree that the name is not optimal.
But I don't have a counterproposal as my naming skills are miserable.

Thanks,
//richard
