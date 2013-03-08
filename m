Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933870Ab3CHH1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 02:27:15 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:42026 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607Ab3CHH1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 02:27:14 -0500
MIME-Version: 1.0
In-Reply-To: <51399154.5030500@redhat.com>
References: <51397D1D.5030602@redhat.com>
	<1750036321.11235774.1362722613994.JavaMail.root@redhat.com>
	<CAE9FiQUtDcwJkPMPfjur8LQ+u0Hc2J7sbxC=xkcemqRQ1_Gd8g@mail.gmail.com>
	<CAE9FiQU7ccdWCL=t=Zn1w33GHpHk56=JXTcotn-Huq9Wiqu7wg@mail.gmail.com>
	<51399154.5030500@redhat.com>
Date: Thu, 7 Mar 2013 23:27:12 -0800
X-Google-Sender-Auth: 32hrMCB61GhrU0IsXOMHe3DtQd4
Message-ID: <CAE9FiQVPaG5P7mG9HoFzCkaxF62hkU5hEtq_FhdT7n+38aNs9A@mail.gmail.com>
Subject: Re: 3.9-rc1: crash kernel panic - not syncing: Can not allocate
 SWIOTLB buffer earlier and can't now provide you with the DMA bounce buffer
From: Yinghai Lu <yinghai@kernel.org>
To: WANG Chao <chaowang@redhat.com>
Cc: CAI Qian <caiqian@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        kexec <kexec@lists.infradead.org>, Dave Young <dyoung@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 11:20 PM, WANG Chao <chaowang@redhat.com> wrote:
>>
>> looks like your system DO have DMAR table, please enable dmar
>> remapping in your kernel config.
>
> I've already got following config:
> CONFIG_DMAR_TABLE=y
> CONFIG_INTEL_IOMMU=y
> CONFIG_IRQ_REMAP=y
>
> but I don't have intel_iommu=on in kernel cmdline. IIRC, iommu will prevent
> 2nd kernel from booting ...

Did you put intel_iommu=on on first and second cpu both?

Thanks

Yinghai
