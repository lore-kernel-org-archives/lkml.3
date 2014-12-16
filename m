Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbaLPCxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 21:53:19 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:65105 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbaLPCxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 21:53:14 -0500
MIME-Version: 1.0
In-Reply-To: <548BBAB2.7010003@mvista.com>
References: <1418354422.5745.101.camel@intel.com>
	<548BBAB2.7010003@mvista.com>
Date: Mon, 15 Dec 2014 18:53:13 -0800
Message-ID: <CAADnVQJ8MT9mUbp2cyMOd-TUZh_fp+y35CGBiw+GEcbCRb+GrA@mail.gmail.com>
Subject: Re: [LKP] [ipmi] BUG: key ffff880fcfc51ed0 not in .data!
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Corey Minyard <cminyard@mvista.com>
Cc: Huang Ying <ying.huang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        LKP ML <lkp@01.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 8:04 PM, Corey Minyard <cminyard@mvista.com> wrote:
> On 12/11/2014 09:20 PM, Huang Ying wrote:
>> FYI, we noticed the below changes on
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
>> commit 2ed09fc090fc0488e2ab27604a141679fe2ef610 ("ipmi: clean up the device handling for the bmc device")
>
> Thanks.  The surprising thing is that this didn't give an error before.
>
> But this should be fixed in linux-next the next time.

when specifically? Is there a fix already?
Quite annoying to see this every boot:
[    4.778018] BUG: key ffff88046458fe20 not in .data!
[    4.778021] ------------[ cut here ]------------
[    4.778061] WARNING: CPU: 1 PID: 1428 at
../kernel/locking/lockdep.c:2991 lockdep_init_map+0x4cd/0x500()
