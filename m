Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890Ab3DOC7X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:59:23 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:36859 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390Ab3DOC7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:59:22 -0400
MIME-Version: 1.0
In-Reply-To: <516B5F1F.1040106@zytor.com>
References: <1365749691-21299-1-git-send-email-yinghai@kernel.org>
	<1365749691-21299-2-git-send-email-yinghai@kernel.org>
	<516B5F1F.1040106@zytor.com>
Date: Sun, 14 Apr 2013 19:59:21 -0700
X-Google-Sender-Auth: pWptohAlzQqe4LCr2v-BIYV9Nv8
Message-ID: <CAE9FiQUGxGveg__VHE0-f0zfuY1ivuDMpQmMb9p0ic5=Hyf91A@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] x86, kdump: Set crashkernel_low automatically
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        WANG Chao <chaowang@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 14, 2013 at 6:59 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/11/2013 11:54 PM, Yinghai Lu wrote:
>
>> +             /*
>> +              * two parts from lib/swiotlb.c:
>> +              *      swiotlb size: user specified with swiotlb= or default.
>> +              *      swiotlb overflow buffer: now is hardcoded to 32k,
>> +              *              round to 8M to cover more others.
>> +              */
>
> This comment is incomprehensible.  "Cover more others"?

i mean other buffers that may need to stay low, but we do not know
them eactly yet.

Thanks

Yinghai
