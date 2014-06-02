Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbaFBLX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 07:23:27 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:38022 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbaFBLXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 07:23:25 -0400
MIME-Version: 1.0
X-Originating-IP: [90.207.204.193]
In-Reply-To: <20140530032010.GA29906@dhcp-16-198.nay.redhat.com>
References: <20140530032010.GA29906@dhcp-16-198.nay.redhat.com>
Date: Mon, 2 Jun 2014 12:23:24 +0100
Message-ID: <CADknwL6Xh+egtg3S0JLrt2eogbWB75MWGA19oG-k97_R9LMTfQ@mail.gmail.com>
Subject: Re: [PATCH]x86 efi: do not export efi runtime map in case old map
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: matt.fleming@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, vgoyal@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 May 2014 04:20, Dave Young <dyoung@redhat.com> wrote:
>
> For ioremapped efi memory aka old_map the virt addresses are not persistant
> across kexec reboot. kexec-tools will read the runtime maps from sysfs then
> pass them to 2nd kernel and assuming kexec efi boot is ok. This will cause
> kexec boot failure.
>
> To address this issue do not export runtime maps in case efi old_map so
> userspace can use no efi boot instead.
>
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  arch/x86/platform/efi/efi.c | 3 +++
>  1 file changed, 3 insertions(+)

Thanks Dave, applied with acks.
