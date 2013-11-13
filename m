Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab3KMQYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 11:24:53 -0500
Received: from multi.imgtec.com ([194.200.65.239]:21147 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775Ab3KMQYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 11:24:52 -0500
Message-ID: <5283A7C0.4080308@imgtec.com>
Date: Wed, 13 Nov 2013 16:24:32 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>
CC: "Steven J. Hill" <Steven.Hill@imgtec.com>,
        LMOL <linux-mips@linux-mips.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Release of Linux MTI-3.10-LTS kernel.
References: <528246BA.10607@imgtec.com> <CAGVrzcYV7f4zN23nSMOp3r9aiSme-mJPEz2OkyLUFDWKfWtGqw@mail.gmail.com>
In-Reply-To: <CAGVrzcYV7f4zN23nSMOp3r9aiSme-mJPEz2OkyLUFDWKfWtGqw@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_11_13_16_24_51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/13 18:29, Florian Fainelli wrote:
> 2013/11/12 Steven J. Hill <Steven.Hill@imgtec.com>:
>> Imagination Technologies is pleased to announce the release of its 3.10 LTS
>> (Long-Term Support) MIPS kernel. The changelog below is based off the stable
>> Linux 3.10.14 release done by Greg Kroah-Hartman in commit
>> 8c15abc94c737f9120d3d4a550abbcbb9be121f6 back on October 1st. The code
>> repository is hosted at the Linux/MIPS project GIT:
>>
>> http://git.linux-mips.org/?p=linux-mti.git;a=summary
>>
>> We look forward to any comments or feedback.
> 
> Nice job! Do you have a rough idea of the delta between your LTS
> kernel and the current status of mainline/pending submissions?

Hi Florian,

Regarding the delta, hopefully the following stats give a rough idea:

I see 105 patches in the mti branch with the following total diffstat:
182 files changed, 18614 insertions(+), 1210 deletions(-)

With the help of git log's cherry-mark feature I count 66 of those
patches corresponding to a patch in mainline since v3.10 (the largest of
which is Aaro's Octeon USB HCD support patch, with 9992 insertions). 42
of these upstream patches were authored by somebody at IMG.

Out of the rest (patches not in mainline), the total insertions is 8175
and total deletions is 826. The largest of these patches by
insertions are:

1) 4e5dd4434d94 MIPS: MIPS32R2 Segment/EVA support upto 3GB
36 files changed, 3819 insertions(+), 173 deletions(-)

2) 0d6f34364a6e MIPS: VPE: Re-implement as writes to a pseudo-device.
4 files changed, 826 insertions(+), 101 deletions(-)

3) 6442e3516c84 MIPS: -mfp64 for abi=o32 ELF binaries support.
17 files changed, 517 insertions(+), 77 deletions(-)

4) 65b4e451fc32 MIPS: Add proAPTIV CPU support.
21 files changed, 505 insertions(+), 44 deletions(-)

I'm optimistic the out-of-mainline delta will drop significantly over time.

Cheers
James

