Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965Ab3CSBKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 21:10:16 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:58077 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455Ab3CSBKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 21:10:15 -0400
MIME-Version: 1.0
X-Originating-IP: [201.75.13.180]
In-Reply-To: <20130105145519.GB32169@linux-youquan.bj.intel.com>
References: <1355850450-26445-1-git-send-email-youquan.song@intel.com>
 <50D0A8CE.7040704@linux.intel.com> <CAE9FiQUfCOip_dJM9gTVsiXH5iHHPzTsnp=sBz2ughMJh1HT8Q@mail.gmail.com>
 <20130105145519.GB32169@linux-youquan.bj.intel.com>
From: Sergio Correia <lists@uece.net>
Date: Mon, 18 Mar 2013 21:09:53 -0400
Message-ID: <CAJyhjX1HbxzfDv963Zi_CJ703P=by+hVdsHhNrH3HrnFvz8amQ@mail.gmail.com>
Subject: Re: [PATCH] x86,apic: Blacklist x2APIC on some platforms
To: Youquan Song <youquan.song@linux.intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Jan 5, 2013 at 10:55 AM, Youquan Song
<youquan.song@linux.intel.com> wrote:
> On Tue, Dec 18, 2012 at 09:42:30AM -0800, Yinghai Lu wrote:
>> On Tue, Dec 18, 2012 at 9:33 AM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>> > On 12/18/2012 09:07 AM, Youquan Song wrote:
>> >> Blacklist x2apic when Nivida graphics enabled on Lenovo ThinkPad T420.
>> >> Also set blacklist x2apic for Lenovo ThinkPad W520 and L520.
>> >
>> > I thought we had gotten reports that the Nvidia correlation was false?
>>
>> that's T520.
>
> Hi hpa,
>
> Yinghai's T520 works when x2APIC enabled, so do not need to blacklist.
>
> Would you like to take the patch?
>

I found this patch after some googling and for the record, it makes my
W520 boot with VT-d enabled and the discrete NVidia card.
Is it still being considered?

thanks,
Sergio

> Thanks
> -Youquan
>
