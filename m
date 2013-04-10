Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964921Ab3DJQNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 12:13:32 -0400
Received: from mail-ia0-f178.google.com ([209.85.210.178]:32998 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937018Ab3DJQNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:13:30 -0400
MIME-Version: 1.0
In-Reply-To: <5164F9E9.3010909@cn.fujitsu.com>
References: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
	<1365119186-23487-3-git-send-email-yinghai@kernel.org>
	<5164F9E9.3010909@cn.fujitsu.com>
Date: Wed, 10 Apr 2013 09:13:29 -0700
X-Google-Sender-Auth: 3bSNncktn7Pw-HiDFbCfCGLbsvE
Message-ID: <CAE9FiQVro+a7ZjHhqNUjev7YJ8bsGmN0A8NqYpQBf=qUfJZbPw@mail.gmail.com>
Subject: Re: [PATCH v3 02/22] x86, microcode: Use common get_ramdisk_image()
From: Yinghai Lu <yinghai@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 10:34 PM, Tang Chen <tangchen@cn.fujitsu.com> wrote:
> On 04/05/2013 07:46 AM, Yinghai Lu wrote:
>>         boot_params_p = (struct boot_params *)__pa_nodebug(&boot_params);
>> -       ramdisk_image = boot_params_p->hdr.ramdisk_image;
>> -       ramdisk_size  = boot_params_p->hdr.ramdisk_size;
>> +       ramdisk_image = get_ramdisk_image(boot_params_p);
>> +       ramdisk_size  = get_ramdisk_image(boot_params_p);
>
>
> Shoule be get_ramdisk_size(boot_params_p) ?
>

oh, will update that.

Thanks

Yinghai
