Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbaH0RHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:07:20 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:43696 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934904AbaH0RHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:07:18 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1408271035351.1460-100000@iolanthe.rowland.org>
References: <CA+eFSM25V2_kKT7EBfPmahTknQu3jMS3+4PC_Af6C+1eHrFhWg@mail.gmail.com>
	<Pine.LNX.4.44L0.1408271035351.1460-100000@iolanthe.rowland.org>
Date: Thu, 28 Aug 2014 01:07:16 +0800
Message-ID: <CA+eFSM1qokxsArUSOwSY8wd-VG_0JYT-pwRhu9-YgZkOccXkDg@mail.gmail.com>
Subject: Re: About the reboot hang issue with EHCI driver on the Baytrail platform
From: Gavin Guo <gavin.guo@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Anthony Wong <anthony.wong@canonical.com>, YK <yk@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Wed, Aug 27, 2014 at 10:38 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 27 Aug 2014, Gavin Guo wrote:
>
>> > Still, why not use the BIOS setting to disable EHCI?
>>
>> It's hardware enablement policy. By default, we can't change the BIOS
>> setting to make the bug disappear until we find out the bug is due to
>> BIOS's bug. Add kernel parameters is the temporary solution for the
>> platform can ship. And if the bug is from kernel, we need to send
>> patches to upstream and pull back to Ubuntu kernel or send to Ubuntu
>> Kernel directly if it's a trivial solution like adding device id.
>> However, as you said, in this case about the bug the root may be from
>> BIOS code. So, we can coordinate with the OEM BIOS team to modify the
>> default BIOS setting.
>
> There is no doubt that the BIOS is buggy.  Your log contains this line:
>
> [    2.804205] pci 0000:00:1d.0: EHCI: BIOS handoff failed (BIOS bug?) 01010001
>
> The only way that can happen is if the BIOS isn't working right.
> However, this may be a different bug from the crashes you've been
> seeing.

Thanks for your comments. I really appreciate your support.

Gavin Guo

>
> Alan Stern
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
