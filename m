Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbaLKT1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:27:45 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65279 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756081AbaLKT1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:27:42 -0500
Message-ID: <5489F025.9010907@nod.at>
Date: Thu, 11 Dec 2014 20:27:33 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
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
References: <CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com>	<87h9x5re41.fsf_-_@x220.int.ebiederm.org>	<87mw6xpzb0.fsf_-_@x220.int.ebiederm.org>	<CALCETrU-o5mPr1jCaLXDuuF6J2N470zAtx=8Fa-SjF=ZpdE8mQ@mail.gmail.com>	<87ppbtn4mv.fsf@x220.int.ebiederm.org>	<CALCETrXSScp77BUJR5NSTh5-RnEZ9rqELSGJBeEzgdQ-OtohuQ@mail.gmail.com>	<87a92xn2io.fsf@x220.int.ebiederm.org>	<87r3w8liw4.fsf@x220.int.ebiederm.org>	<87iohklfvj.fsf_-_@x220.int.ebiederm.org>	<87mw6vh31e.fsf_-_@x220.int.ebiederm.org>	<20141210224822.GG20012@ubuntumail> <5488CE4D.1000606@nod.at> <87r3w7f5yc.fsf@x220.int.ebiederm.org>
In-Reply-To: <87r3w7f5yc.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 11.12.2014 um 00:19 schrieb Eric W. Biederman:
> Richard Weinberger <richard@nod.at> writes:
> 
>> Am 10.12.2014 um 23:48 schrieb Serge Hallyn:
>>> Quoting Eric W. Biederman (ebiederm@xmission.com):
>>>>
>>>> Will people please test these patches with their container project?
>>>>
>>>> These changes break container userspace (hopefully in a minimal way) if
>>>> I could have that confirmed by testing I would really appreciate it.  I
>>>> really don't want to send out a bug fix that accidentally breaks
>>>> userspace again.
>>>>
>>>> The only issue sort of under discussion is if there is a better name for
>>>> /proc/<pid>/setgroups, and the name of the file will not affect the
>>>> functionality of the patchset.
>>>>
>>>> With the code reviewed and written in simple obviously correct, easily
>>>> reviewable ways I am hoping/planning to send this to Linus ASAP.
>>>>
>>>> Eric
>>>
>>> Is there a git tree we can clone?
>>
>> I was about to ask that too.
>> Hopefully I can tomorrow find some time for testing.
> 
> git pull git.kernel.org:/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-testing
> 
> That holds my entire queue of fixes against 3.18-rc6

So far nothing broke on my libvirt-lxc test bed. :-)
Tested with openSUSE 13.2 and libvirt 1.2.9.

Tested-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard
