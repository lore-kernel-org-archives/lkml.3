Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab3LFAuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 19:50:15 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:49012 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab3LFAuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 19:50:12 -0500
MIME-Version: 1.0
In-Reply-To: <20131205154358.GB7460@kroah.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
	<003101ceefb5$dc1b0380$94510a80$%han@samsung.com>
	<CAAb+SYZh1KXHQV0GSeFtOkYC=3acZYRvSnqf-VR2rH=T69nWxg@mail.gmail.com>
	<20131205154358.GB7460@kroah.com>
Date: Fri, 6 Dec 2013 08:50:11 +0800
Message-ID: <CAAb+SYYpELtb5+r93HR1KvF8U5AL2ZTD0cU9VXX+2Pb=A5fGbQ@mail.gmail.com>
Subject: Re: [PATCH 28/39] staging: remove DEFINE_PCI_DEVICE_TABLE macro
From: ZHAO Gang <gamerh2o@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jingoo Han <jg1.han@samsung.com>,
        STAGING SUBSYSTEM <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 5, 2013 at 11:43 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Dec 05, 2013 at 05:06:33PM +0800, ZHAO Gang wrote:
>> On Tue, Dec 3, 2013 at 7:26 AM, Jingoo Han <jg1.han@samsung.com> wrote:
>> > Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
>> > is not preferred.
>> >
>> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
>> >
>>
>> I think you misunderstood the checkpatch.pl warning, it tells you what
>> to do, not what not to do.
>>
>> WARNING: Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id
>>
>> This means use DEFINE_PCI_DEVICE_TABLE to replace struct
>> pci_device_id, not reverse.
>
> No, checkpatch is wrong, and is being fixed, this patch is correct.

Oh, I didn't notice the recent checkpatch update, sorry for the noise.
