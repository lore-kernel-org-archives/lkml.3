Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764222Ab3DDR7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 13:59:42 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:32999 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764208Ab3DDR7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 13:59:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130404174830.GR9425@htj.dyndns.org>
References: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
	<1362897887-30808-3-git-send-email-yinghai@kernel.org>
	<20130404174830.GR9425@htj.dyndns.org>
Date: Thu, 4 Apr 2013 10:59:40 -0700
X-Google-Sender-Auth: CKyDhpqXfECNiHWfBU3jpjM7Tsg
Message-ID: <CAE9FiQVYCHVmLcDZaOuN4WaodKBUJ4xjrr7ssxMk3iqAPSscUA@mail.gmail.com>
Subject: Re: [PATCH v2 02/20] x86, microcode: Use common get_ramdisk_image()
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 10:48 AM, Tejun Heo <tj@kernel.org> wrote:
> On Sat, Mar 09, 2013 at 10:44:29PM -0800, Yinghai Lu wrote:
>> Use common get_ramdisk_image() to get ramdisk start phys address.
>>
>> We need this to get correct ramdisk adress for 64bit bzImage that
>> initrd can be loaded above 4G by kexec-tools.
>
> Is this a bug fix?  Can it actually happen?

Yes, it could happen.
When second kernel have early microcode updating support, and it would search
wrong wrong place for ramdisk.

Thanks

Yinghai
