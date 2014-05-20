Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaETMLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 08:11:16 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:40477 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbaETMLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 08:11:12 -0400
Message-ID: <537B46C1.8020802@gmail.com>
Date: Tue, 20 May 2014 14:12:49 +0200
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>
Subject: Re: kernel 3.14.2 oops: seems related to EFI
References: <53777F7B.8060407@gmail.com> <20140518134206.GA8040@pd.tnic> <5379AE46.3000407@gmail.com> <20140520115421.GH4798@console-pimps.org>
In-Reply-To: <20140520115421.GH4798@console-pimps.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 01:54 PM, Matt Fleming wrote:
> On Mon, 19 May, at 09:09:58AM, Francis Moreau wrote:
>>
>> I don't know, I can't really afford to configure/compile/test this new
>> kernel, sorry.
> 
> It would be useful to know whether this issue still occurs when booting
> with the efi=old_map kernel parameter.
> 

ok I can try to boot with that parameter and see if the issue happens
again. Unfortunately if it doesn't, we couldn't tell.

Thanks
