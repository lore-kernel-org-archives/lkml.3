Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab3CFTem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 14:34:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:13802 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab3CFTel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 14:34:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,795,1355126400"; 
   d="scan'208";a="296136670"
Message-ID: <51379A4F.4020200@linux.intel.com>
Date: Wed, 06 Mar 2013 11:34:39 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.9-rc1
References: <CA+55aFx0HcOXKpxmZzM5jcbAaOroxafomX5ggMFV4A=py1qh-Q@mail.gmail.com> <20130306080642.GA535@polaris.bitmath.org> <51370990.5040508@linux.intel.com> <20130306100743.GA407@polaris.bitmath.org> <CAE9FiQXT4O3GOzm_OoFJG=vc=5LpfBkTEbAO_3xjerBGS_Gy=A@mail.gmail.com> <20130306193612.GA513@polaris.bitmath.org>
In-Reply-To: <20130306193612.GA513@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 11:36 AM, Henrik Rydberg wrote:
> Hi Yinghai,
> 
>>>> Can you get a boot log with "debug memblock=debug" from the last
>>>> successful commit point?  Are you booting EFI or BootCamp?
>>>
>>> Attached the dmesg log, booting from f763ad1 which is on top of
>>> 3.7-rc6. I am booting with EFI_STUB, straight into the kernel.
>>> The command line and modules are built in.
>>
>> will check that EFI_STUB path.
>>
>> Can you check bootloader like grub.efi ?
> 
> I checked, same story. I tried without EFI_STUB, no joy. I ran with
> and without nouveau, just in case. Without the patch, everything
> works. With the patch, nothing works, and no output at all.
> 
> With a bit of luck, I could maybe get the first lines of output using
> grub.efi, but frankly I cannot remember if that ever worked on this
> machine.
> 

A simpler one is efilinux:

https://github.com/mfleming/efilinux

	-hpa


