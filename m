Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbbA1UXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:23:37 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:56287 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795AbbA1UXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:23:31 -0500
MIME-Version: 1.0
In-Reply-To: <CACzj_yVAyAm1UHtqV6TbZ-Qa5w4GH723JF_+4ptZTm+JE1yj3g@mail.gmail.com>
References: <CACzj_yW2j7Bqs=9iOgQ0Wh6SwAHNkH3SYMboKFaWzRT+yarfwA@mail.gmail.com>
 <CACzj_yVAyAm1UHtqV6TbZ-Qa5w4GH723JF_+4ptZTm+JE1yj3g@mail.gmail.com>
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Thu, 29 Jan 2015 00:27:02 +0800
Message-ID: <CACzj_yW4uNO1_vYButpcj6+fvGmqjTNFMWaWA1Btgxf=+7+YDg@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] KVM: nVMX: Use hardware MSR bitmap
To: Paolo Bonzini <pbonzini@redhat.com>, "gleb@kernel.org" <gleb@kernel.org>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>,
        =?UTF-8?B?6IyD5paH5LiA?= <fanwenyi0529@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 11:52 PM, Wincy Van <fanwenyi0529@gmail.com> wrote:
> Sorry, please ignore this mail, the subject is wrong : (
>

I was confused by gmail's conversation view, gmail put this patch in
the v3's conversation.
please ignore this.

Thanks,
Wincy

> On Wed, Jan 28, 2015 at 11:50 PM, Wincy Van <fanwenyi0529@gmail.com> wrote:
>> Currently, if L1 enables MSR_BITMAP, we will emulate this feature,
>> all of L2's msr access is intercepted by L0. Since many features
>> like virtualize x2apic mode has a complicated logic and it is
>> difficult for us to emulate, we should use hardware and merge
