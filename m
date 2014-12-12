Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbaLLHEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 02:04:33 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:24788 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752496AbaLLHE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 02:04:29 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44934382"
From: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Richard Weinberger <richard@nod.at>
CC: linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Josh Triplett <josh@joshtriplett.org>, stable <stable@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Kenton Varda <kenton@sandstorm.io>,
        LSM <linux-security-module@vger.kernel.org>,
        "Michael Kerrisk-manpages" <mtk.manpages@gmail.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [CFT] Can I get some Tested-By's on this series?
Thread-Topic: [CFT] Can I get some Tested-By's on this series?
Thread-Index: AQHQFJhMWqIhVf91bkKixCnmDgMW9ZyI538AgAAAtICAAI7wMoAB0W1A
Date: Fri, 12 Dec 2014 06:56:13 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E737908F5@G08CNEXMBPEKD02.g08.fujitsu.local>
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
	<20141210224822.GG20012@ubuntumail> <5488CE4D.1000606@nod.at>
 <87r3w7f5yc.fsf@x220.int.ebiederm.org>
In-Reply-To: <87r3w7f5yc.fsf@x220.int.ebiederm.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.226.240]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBC74glq017478



> -----Original Message-----
> From: containers-bounces@lists.linux-foundation.org
> [mailto:containers-bounces@lists.linux-foundation.org] On Behalf Of Eric W.
> Biederman
> Sent: Thursday, December 11, 2014 7:20 AM
> To: Richard Weinberger
> Cc: linux-man; Kees Cook; Linux API; Linux Containers; Serge Hallyn; Josh Triplett;
> stable; Andy Lutomirski; Kenton Varda; LSM; Michael Kerrisk-manpages; Casey
> Schaufler; Andrew Morton; linux-kernel@vger.kernel.org
> Subject: Re: [CFT] Can I get some Tested-By's on this series?
> 
> Richard Weinberger <richard@nod.at> writes:
> 
> > Am 10.12.2014 um 23:48 schrieb Serge Hallyn:
> >> Quoting Eric W. Biederman (ebiederm@xmission.com):
> >>>
> >>> Will people please test these patches with their container project?
> >>>
> >>> These changes break container userspace (hopefully in a minimal way) if
> >>> I could have that confirmed by testing I would really appreciate it.  I
> >>> really don't want to send out a bug fix that accidentally breaks
> >>> userspace again.
> >>>
> >>> The only issue sort of under discussion is if there is a better name for
> >>> /proc/<pid>/setgroups, and the name of the file will not affect the
> >>> functionality of the patchset.
> >>>
> >>> With the code reviewed and written in simple obviously correct, easily
> >>> reviewable ways I am hoping/planning to send this to Linus ASAP.
> >>>
> >>> Eric
> >>
> >> Is there a git tree we can clone?
> >
> > I was about to ask that too.
> > Hopefully I can tomorrow find some time for testing.
> 
> git pull git.kernel.org:/pub/scm/linux/kernel/git/ebiederm/user-namespace.git
> for-testing
> 
> That holds my entire queue of fixes against 3.18-rc6
> 

Tested on Fedora20 with libvirt 1.2.11, works fine.

Tested-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>

Thanks,
- Chen
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
