Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab3DPQkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 12:40:01 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:44109 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932673Ab3DPQj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 12:39:59 -0400
Message-ID: <516D7EDB.6090201@intel.com>
Date: Tue, 16 Apr 2013 17:39:55 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Sergey Vlasov <vsu@altlinux.ru>
CC: Matthew Garrett <matthew.garrett@nebula.com>, linux-efi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] efi: Export efi_query_variable_store() for efivars.ko
References: <1366056587-24414-4-git-send-email-matthew.garrett@nebula.com> <1366122669-20898-1-git-send-email-vsu@altlinux.ru> <1366122669-20898-2-git-send-email-vsu@altlinux.ru>
In-Reply-To: <1366122669-20898-2-git-send-email-vsu@altlinux.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/04/13 15:31, Sergey Vlasov wrote:
> Fixes build with CONFIG_EFI_VARS=m which was broken after the commit
> "x86, efivars: firmware bug workarounds should be in platform code".
> 
> Signed-off-by: Sergey Vlasov <vsu@altlinux.ru>
> ---
>  arch/x86/platform/efi/efi.c | 1 +
>  1 file changed, 1 insertion(+)

Applied, thanks!

