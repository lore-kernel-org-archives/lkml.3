Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878AbaE3KDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 06:03:17 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:34240 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177AbaE3KDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 06:03:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140529182524.GA22969@kroah.com>
References: <1396010535-2654-1-git-send-email-daniel.thompson@linaro.org>
 <1401358423-31532-1-git-send-email-daniel.thompson@linaro.org>
 <CAGsJ_4ypSdP-i35BaQaciPo-g=+8Z5-T2MV5zgDP98BMciGbGw@mail.gmail.com> <20140529182524.GA22969@kroah.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 30 May 2014 18:02:53 +0800
X-Google-Sender-Auth: _g84Uv-rwb66sZ12CkWSFp1QHhE
Message-ID: <CAGsJ_4z7zikhK5ba22OzWEXOKmHCnazyYHwMUVCGRs5Ca-Wi8g@mail.gmail.com>
Subject: Re: [PATCH tty-next] serial: sirf: Fix compilation failure
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        Jiri Slaby <jslaby@suse.cz>, Qipan Li <Qipan.Li@csr.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-30 2:25 GMT+08:00 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> On Thu, May 29, 2014 at 08:14:02PM +0800, Barry Song wrote:
>> 2014-05-29 18:13 GMT+08:00 Daniel Thompson <daniel.thompson@linaro.org>:
>> > After 07d410e0) serial: sirf: fix spinlock deadlock issue it is no longer
>> > possiblet to compile this driver. The rename of one of the spinlocks is
>> > faulty. After looking at the original patch I believe this is the correct
>> > fix.
>> >
>> > Compile tested using ARM's multi_v7_defconfig
>> >
>> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> > Cc: Jiri Slaby <jslaby@suse.cz>
>> > Cc: Barry Song <baohua@kernel.org>
>> > Cc: Qipan Li <Qipan.Li@csr.com>
>> > Cc: linux-serial@vger.kernel.org
>> > Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
>>
>> Qipan prepared a same patch to fix this.
>
> Why didn't he send it?

it is not that he didn't want to send, it is because Daniel has sent
the same patch earlier.

>

-barry
