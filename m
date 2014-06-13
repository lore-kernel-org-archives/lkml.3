Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaFMFvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 01:51:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43780 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbaFMFvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 01:51:17 -0400
Message-ID: <539A914A.9020700@zytor.com>
Date: Thu, 12 Jun 2014 22:51:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Kui Zhang <kuizhang@gmail.com>, Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Segmentation fault on all golang executables
References: <CAKx2Y1kBy-mrxm+1u88XVL2Z7gYKQe5U-EG2SBTzNCRAs_UVVw@mail.gmail.com>	<CALCETrWMBAxz9yn4MMugjZGC_Dsi2p855+e99Qhr0Ab+OaGRXw@mail.gmail.com>	<CALCETrV0zm_9a_jNxaw_=Ai1dozeqgFJYRh5xAmq_Qa7ErT-RQ@mail.gmail.com>	<CAKx2Y1kTuK2cCn_uhVMgU5SeLsjXzHcFRmds7LP7-QG8BMqAdA@mail.gmail.com>	<CALCETrXnXp45iRC1h=_pOYrvXPc=hrTYnnVgsUg+i9URVfJTow@mail.gmail.com> <CAKx2Y1mpUk_PurLG7w4ZdJ64Qw_dGgdM6yi2ecwwxzLC0CrhqQ@mail.gmail.com>
In-Reply-To: <CAKx2Y1mpUk_PurLG7w4ZdJ64Qw_dGgdM6yi2ecwwxzLC0CrhqQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 10:47 PM, Kui Zhang wrote:
> Thanks for the patches. The workaround works.
> 
> Stupid idea, maybe something in dmesg to help spark conversions, when
> this workaround is hit?
> 
> Looks like golang people are close.
> 

The kernel won't even know.

	-hpa


