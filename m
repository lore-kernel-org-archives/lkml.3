Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965161Ab3DTAOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 20:14:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56261 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965091Ab3DTAOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 20:14:38 -0400
Message-ID: <5171DDB1.3020306@zytor.com>
Date: Fri, 19 Apr 2013 17:13:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [GIT PULL] EFI fixes for v3.10
References: <51718128.7010405@console-pimps.org>
In-Reply-To: <51718128.7010405@console-pimps.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2013 10:38 AM, Matt Fleming wrote:
> 
> Richard Weinberger (2):
>       x86,efi: Check max_size only if it is non-zero.
>       x86,efi: Implement efi_no_storage_paranoia parameter
> 

OK, I'll pull this for now, but this *really* need to be an automatic
quirk of some sort, especially when there is a named board in the mix...

	-hpa


