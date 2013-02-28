Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab3B1Eyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 23:54:37 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:41818 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab3B1Eyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 23:54:36 -0500
Message-ID: <512EE2F5.2080900@oracle.com>
Date: Wed, 27 Feb 2013 20:54:13 -0800
From: Srinivas Eeda <srinivas.eeda@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: "Ramappa, Ravi (NSN - IN/Bangalore)" <ravi.ramappa@nsn.com>,
        "ocfs2-users@oss.oracle.com" <ocfs2-users@oss.oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, david@sigma-star.at
Subject: Re: [Ocfs2-users] Kernel panic due to ocfs2
References: <EB937501617BFC44BE90EDA24CA6A13A0117EB@SGSIMBX003.nsn-intra.net> <512C56AF.1030801@oracle.com> <CAFLxGvyQmPz_iK26NavuRdBWAFiWzmt8BMfL8f6rg_Qm4LF7WQ@mail.gmail.com> <CAFLxGvycGCyeg7AhJ=3J0ztZfgYLmyKZSrzNUd5ymAb-tSd4qg@mail.gmail.com>
In-Reply-To: <CAFLxGvycGCyeg7AhJ=3J0ztZfgYLmyKZSrzNUd5ymAb-tSd4qg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2013 03:52 AM, richard -rw- weinberger wrote:
> On Tue, Feb 26, 2013 at 8:54 AM, richard -rw- weinberger
> <richard.weinberger@gmail.com> wrote:
>> On Tue, Feb 26, 2013 at 7:31 AM, Srinivas Eeda <srinivas.eeda@oracle.com> wrote:
>>> This is due to a race in lock mastery/purge. I have recently fixed this
>>> problem but haven't yet submitted the patch to mainline. Please file a
>>> Service request with Oracle to get a one-off fix.
>> Please submit the patch immediately.
>> Why does one need a f§&"!#$ SR from Oracle to have this fixed?
> So, where can I find this patch?
> Can you please share it with us insignificant and rubbishy community folks?
Here is the patch against mainline which I haven't yet submitted because 
I have not finished testing on mainline kernel yet. I am running into 
another unrelated crashes during testing. I am forwarding the patch to 
you assuming you are looking for this fix.

https://oss.oracle.com/~seeda/patches/dlm-race/

The other person who emailed about the problem was running older ocfs2 
version(1.4-10). Which is where I originally debugged, patched and 
tested the fix. So I offered to help him.
>
> https://oss.oracle.com/projects/ocfs2/source.html points to
> http://git.kernel.org/?p=linux/kernel/git/jlbec/ocfs2.git;a=summary
> This tree seems horrible outdated...
>

