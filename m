Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965279AbaGPOe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:34:28 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:55716 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965090AbaGPOeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:34:22 -0400
Date: Wed, 16 Jul 2014 15:34:09 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-efi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: Re: [PATCH] x86, eboot: Support initrd loaded above 4G
Message-ID: <20140716143409.GC32039@console-pimps.org>
References: <1402773821-15995-1-git-send-email-yinghai@kernel.org>
 <20140618142819.GN24049@console-pimps.org>
 <20140709182651.GB15932@console-pimps.org>
 <CAE9FiQVP6d5GhFBBmX5HDo0w0oKJSizdKvepq5t6vhGNj=W9sg@mail.gmail.com>
 <20140711074029.GD5952@console-pimps.org>
 <20140715151025.GB32039@console-pimps.org>
 <53C54C62.8070403@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C54C62.8070403@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul, at 08:44:34AM, H. Peter Anvin wrote:
> 
> Do we know what the Windows bootloader does?  I thought it did use the
> EFI File Protocol?

Good question. I'm not sure what the answer is, I'll try and find some
time to take a look.

-- 
Matt Fleming, Intel Open Source Technology Center
