Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966445Ab3DQMtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 08:49:22 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:54654 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966162Ab3DQMtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 08:49:16 -0400
Message-ID: <516E9A11.1040404@console-pimps.org>
Date: Wed, 17 Apr 2013 13:48:17 +0100
From: Matt Fleming <matt@console-pimps.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tom Gundersen <teg@jklm.no>
CC: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v2 0/6] Chainsaw efivars.c
References: <1366148520-29954-1-git-send-email-matt@console-pimps.org> <CAG-2HqVBiSMp648F=zdUBDWQ49_a=rEPJ_TH__zWtaPSjju-KQ@mail.gmail.com>
In-Reply-To: <CAG-2HqVBiSMp648F=zdUBDWQ49_a=rEPJ_TH__zWtaPSjju-KQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2013 01:30 AM, Tom Gundersen wrote:
> Hi Matt,
> 
> On Tue, Apr 16, 2013 at 11:41 PM, Matt Fleming <matt@console-pimps.org> wrote:
>> This patch series introduces the new efivar_entry API, and splits out the major
>> parts of efivars.c into new files. In particular, having the efivarfs code
>> under fs/ allows building an efivarfs.ko module, which means mount(8) can
>> automatically load it.
>>
>> The remaining EFI code is repositioned under drivers/firmware/efi/.
> 
> These all look good to me, so feel free to add my Reviewed-by.
> 
> Tested on top of 3.9-rc7, with everything built as modules. Everything
> works as intended: systemd correctly detects it is on an EFI system,
> so mounts efivarfs, which auto-loads the required modules.
> 
> Thanks a lot!

Thanks for reviewing and testing! I've added your Reviewed-by and
Tested-by tags to all 5 patches (but not the one you authored). I found
a bug in PATCH 3, so I've sent out a v3 of the series.

Peter, I've pulled these 6 patches into the 'chainsaw' branch in the EFI
repo. I think the prudent thing to do (as you previously suggested) is
to merge that branch into tip as a separate topic branch, just in case
we need to drop it before the merge window opens.

-- 
Matt Fleming, Intel Open Source Technology Center
