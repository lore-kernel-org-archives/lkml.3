Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934085Ab3DKNYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:24:19 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:45123 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752116Ab3DKNYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:24:18 -0400
Message-ID: <5166B97B.6080806@console-pimps.org>
Date: Thu, 11 Apr 2013 14:24:11 +0100
From: Matt Fleming <matt@console-pimps.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: matt.fleming@intel.com, linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 2/3] Revert "x86, efivars: firmware bug workarounds
 should be in platform code"
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com> <1365615967-27346-1-git-send-email-matthew.garrett@nebula.com> <1365615967-27346-2-git-send-email-matthew.garrett@nebula.com>
In-Reply-To: <1365615967-27346-2-git-send-email-matthew.garrett@nebula.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/13 18:46, Matthew Garrett wrote:
> This reverts commit a6e4d5a03e9e3587e88aba687d8f225f4f04c792. Doing this
> workaround properly requires us to work within the variable code.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> ---
>  arch/x86/platform/efi/efi.c | 25 -------------------------
>  drivers/firmware/efivars.c  | 18 +++++++++++++++---
>  include/linux/efi.h         |  9 +--------
>  3 files changed, 16 insertions(+), 36 deletions(-)

Does it really? Why can't you just hook into the get_next_variable() and
set_variable() functions in arch/x86/platform/efi/efi.c?

-- 
Matt Fleming, Intel Open Source Technology Center
