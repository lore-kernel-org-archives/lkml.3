Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbaFBLbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 07:31:22 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:37457 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaFBLbU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 07:31:20 -0400
MIME-Version: 1.0
In-Reply-To: <1401705066-2808-1-git-send-email-catalin.marinas@arm.com>
References: <1401705066-2808-1-git-send-email-catalin.marinas@arm.com>
Date: Mon, 2 Jun 2014 12:31:20 +0100
Message-ID: <CAL01qpuXkAw+87vZ-j4c3tu5qyj7sPdJXA+F4aP-O_XPpc=5JA@mail.gmail.com>
Subject: Re: [PATCH] efi: Fix compiler warnings (unused, const, type)
From: "Fleming, Matt" <matt.fleming@intel.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 June 2014 11:31, Catalin Marinas <catalin.marinas@arm.com> wrote:
> This patch fixes a few compiler warning in the efi code for unused
> variable, discarding const qualifier and wrong pointer type:
>
> drivers/firmware/efi/fdt.c|66 col 22| warning: unused variable ‘name’ [-Wunused-variable]
> drivers/firmware/efi/efi.c|368 col 3| warning: passing argument 3 of ‘of_get_flat_dt_prop’ from incompatible pointer type [enabled by default]
> drivers/firmware/efi/efi.c|368 col 8| warning: assignment discards ‘const’ qualifier from pointer target type [enabled by default]
>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>
> Matt,
>
> Unless you have fixed these already, please consider applying (warnings in
> latest next/master branch).

Thanks, applied to arm64-efi.
