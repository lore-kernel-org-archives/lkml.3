Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936017Ab3DKPNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:13:23 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:49799 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3DKPNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:13:22 -0400
Message-ID: <5166D310.2080901@intel.com>
Date: Thu, 11 Apr 2013 16:13:20 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: cbouatmailru@gmail.com, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, matthew.garrett@nebula.com
Subject: Re: [PATCH 1/2] x86,efi: Check max_size only if it is non-zero.
References: <1365584375-9372-1-git-send-email-richard@nod.at>
In-Reply-To: <1365584375-9372-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/13 09:59, Richard Weinberger wrote:
> Some EFI implementations return always a MaximumVariableSize of 0,
> check against max_size only if it is non-zero.
> My Intel DQ67SW desktop board has such an implementation.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/x86/platform/efi/efi.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Applied, thanks!

