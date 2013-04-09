Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab3DIJiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:38:46 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:45272 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934440Ab3DIJil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:38:41 -0400
Message-ID: <5163E19E.5000507@console-pimps.org>
Date: Tue, 09 Apr 2013 10:38:38 +0100
From: Matt Fleming <matt@console-pimps.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: matt.fleming@intel.com, cbouatmailru@gmail.com, ccross@android.com,
        keescook@chromium.org, tony.luck@intel.com, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, matthew.garrett@nebula.com
Subject: Re: [PATCH 2/2] efivars: Implement no_storage_paranoia parameter
References: <1365373938-25993-1-git-send-email-richard@nod.at> <1365373938-25993-2-git-send-email-richard@nod.at>
In-Reply-To: <1365373938-25993-2-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/13 23:32, Richard Weinberger wrote:
> Using this parameter one can disable the storage_size/2 check if
> he is really sure that the UEFI does sane gc.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/firmware/efivars.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

You need to make it clear that enabling this option may brick your
machine if your firmware is buggy.

-- 
Matt Fleming, Intel Open Source Technology Center
