Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422871Ab3DFMrY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 08:47:24 -0400
Received: from mout.gmx.net ([212.227.17.21]:59545 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422847Ab3DFMrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 08:47:23 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+G6wk0gSyGI8HpRFAuZnGqRzE7k+L1JruGoX/t5k
	q/vKRVZlyWwRbN
Message-ID: <51601958.3090806@gmx.de>
Date: Sat, 06 Apr 2013 14:47:20 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130405 Thunderbird/17.0.5
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: "user-mode-linux-user@lists.sourceforge.net" 
	<user-mode-linux-user@lists.sourceforge.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: user mode linux: trinity syscall "madvise" triggers quickly BUG:
 Bad page map
References: <515DB2A6.7020902@gmx.de> <CAFLxGvyDxdL9BJHFH5O6OSqZ3ZyBatBvmZGJWP3B=D=0xcgVng@mail.gmail.com>
In-Reply-To: <CAFLxGvyDxdL9BJHFH5O6OSqZ3ZyBatBvmZGJWP3B=D=0xcgVng@mail.gmail.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2013 01:43 PM, richard -rw- weinberger wrote:
>> What I get with the this trinity command line
>>
>> gt; trinity --children 2 -c madvise
> 
> Does the attached patch fix the problem?

yes, the issue for this syscall is fixed now.

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
