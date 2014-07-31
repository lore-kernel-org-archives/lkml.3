Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397AbaGaN2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:28:06 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbaGaN2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:28:04 -0400
Message-ID: <53DA4461.5050706@nod.at>
Date: Thu, 31 Jul 2014 15:28:01 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jan Hejl <jh@excello.cz>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Sudden kernel panics on AMD Opteron platforms with hardened kernel
References: <53DA3C5C.3040508@excello.cz> <CAFLxGvz5ph_Sk7XmtCMzSCMj-nOPFm8=phoc3Ng_+gyFjTDh7A@mail.gmail.com> <53DA4074.9030300@excello.cz>
In-Reply-To: <53DA4074.9030300@excello.cz>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 31.07.2014 15:11, schrieb Jan Hejl:
> 
> Dne 31.7.2014 v 15:04 Richard Weinberger napsal(a):
>> On Thu, Jul 31, 2014 at 2:53 PM, Jan Hejl <jh@excello.cz> wrote:
>>> Hello,
>>>
>>> i'm facing sudden kernel panics. Last one happened few minutes ago.
>>> Unfortunatelly only output that i've catched is limited thanks to low
>>> resolution of console screen. See screenshot attached.
>>>
>>> Below is output of the ver_linux script.
>>>
>>> Linux aq 3.14.12-hardened-r2 #1 SMP Tue Jul 22 18:47:50 CEST 2014 x86_64 AMD
>> Does the problem also happen with a vanilla kernel?
> Didn't tried yet.

Please do so. Nobody here can help you if you use a modified/broken kernel.

> As I talked to my collegues we found that these bugs are someway random that it may be related to https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61904. Is it possible?

According to your 1st mail you've built the kernel using an older gcc.

Thanks,
//richard
