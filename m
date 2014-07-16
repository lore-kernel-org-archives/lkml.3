Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964990AbaGPOp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:45:26 -0400
Received: from duck.fensystems.co.uk ([212.13.204.60]:49382 "EHLO
	duck.fensystems.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933779AbaGPOpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:45:20 -0400
Message-ID: <53C68FFB.1090301@fensystems.co.uk>
Date: Wed, 16 Jul 2014 15:45:15 +0100
From: Michael Brown <mbrown@fensystems.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>, "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-efi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: Re: [PATCH] x86, eboot: Support initrd loaded above 4G
References: <1402773821-15995-1-git-send-email-yinghai@kernel.org> <20140618142819.GN24049@console-pimps.org> <20140709182651.GB15932@console-pimps.org> <CAE9FiQVP6d5GhFBBmX5HDo0w0oKJSizdKvepq5t6vhGNj=W9sg@mail.gmail.com> <20140711074029.GD5952@console-pimps.org> <20140715151025.GB32039@console-pimps.org> <53C54C62.8070403@zytor.com> <20140716143409.GC32039@console-pimps.org>
In-Reply-To: <20140716143409.GC32039@console-pimps.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/07/14 15:34, Matt Fleming wrote:
> On Tue, 15 Jul, at 08:44:34AM, H. Peter Anvin wrote:
>> Do we know what the Windows bootloader does?  I thought it did use the
>> EFI File Protocol?
>
> Good question. I'm not sure what the answer is, I'll try and find some
> time to take a look.

I'm in the middle of related work at the moment: trying to persuade UEFI 
WinPE to load its files from the virtual file system exposed by iPXE. 
I'll let you know what I find.

Michael
