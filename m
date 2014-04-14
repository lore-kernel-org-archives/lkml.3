Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbaDNNbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 09:31:18 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:56412 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaDNNbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 09:31:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140413220334.GE22728@two.firstfloor.org>
References: <1396882237-27608-1-git-send-email-ling.ma@alipay.com>
	<877g71jdl8.fsf@tassilo.jf.intel.com>
	<CAOGi=dPOEnNOLfnxTfvsVupRWQZtGs7-9LxDF8g2Kbun2v0hQA@mail.gmail.com>
	<CAOGi=dMbRv6S+UGthYTCvW=C7hBRwpnZdM-BYYqT1fn=kF2SLg@mail.gmail.com>
	<20140413220334.GE22728@two.firstfloor.org>
Date: Mon, 14 Apr 2014 21:31:16 +0800
Message-ID: <CAOGi=dOoCkU5Ni8r7pyejMuSdkMt2jOPs2J2OEQ9YxABxNYibw@mail.gmail.com>
Subject: Re: [PATCH RFC] x86:Improve memset with general 64bit instruction
From: Ling Ma <ling.ma.program@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, neleai@seznam.cz,
        linux-kernel@vger.kernel.org, Ling Ma <ling.ml@alibaba-inc.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel version 3.14 shows memcpy, memset occur 19622 and  14189
times respectively.
so memset is still important for us, correct?

Thanks
Ling

2014-04-14 6:03 GMT+08:00, Andi Kleen <andi@firstfloor.org>:
> On Sun, Apr 13, 2014 at 11:11:59PM +0800, Ling Ma wrote:
>> Any further comments  ?
>
> It would be good to test on some more machines that you don't cause
> regressions.
>
> But I'm not aware of any workload that is doing a lot of memset (not
> counting clear_page).  Copies likely matter much more.
>
> -Andi
>
