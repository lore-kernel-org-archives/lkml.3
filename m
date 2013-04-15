Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab3DOOu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 10:50:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57726 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087Ab3DOOu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 10:50:27 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <516B9714.80007@sr71.net>
References: <1365683207-42425-1-git-send-email-trenn@suse.de> <1365683207-42425-6-git-send-email-trenn@suse.de> <CAE9FiQXnZzVC7dtvXWrqz=jYAGH053R8Vw1qkrMd2F+hAaMxdQ@mail.gmail.com> <5166D18A.7090800@zytor.com> <20130412143104.GA4301@redhat.com> <5168208B.7050107@zytor.com> <51688803.8020401@sr71.net> <516B87A6.9080708@jp.fujitsu.com> <516B9714.80007@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 5/5] kexec: X86: Pass memory ranges via e820 table instead of memmap= boot parameter
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 15 Apr 2013 07:49:13 -0700
To: Dave Hansen <dave@sr71.net>, HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cliff Wickman <cpw@sgi.com>, Simon Horman <horms@verge.net.au>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Renninger <trenn@suse.de>,
        Vivek Goyal <vgoyal@redhat.com>
Message-ID: <0ad804f8-7ed2-4952-bd96-b169beece359@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is also true on some x86 systems.

Dave Hansen <dave@sr71.net> wrote:

>On 04/14/2013 09:52 PM, HATAYAMA Daisuke wrote:
>> This sounds like there's no such issue on x86 cache mechanism. Is it
>> correct? If so, what is the difference between ia64 and x86 cache
>> mechanisms?
>
>I'm just going by the code comments:
>
>drivers/char/mem.c
>>                 /*
>>                  * On ia64 if a page has been mapped somewhere as
>uncached, then
>>                  * it must also be accessed uncached by the kernel or
>data
>>                  * corruption may occur.
>>                  */

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
