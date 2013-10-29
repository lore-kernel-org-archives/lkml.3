Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab3J2Fze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 01:55:34 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:49570 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3J2Fzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 01:55:32 -0400
Message-ID: <526F4DCF.5010406@synopsys.com>
Date: Tue, 29 Oct 2013 11:25:27 +0530
From: Vineet Gupta <vineetg76@gmail.com>
Organization: Synopsys
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: James Hogan <james.hogan@imgtec.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [PATCH v2] arch: use ASM_NL instead of ';' for assembler new
 line character in the macro
References: <526E3CE2.2070405@asianux.com> <526E6A92.6090301@synopsys.com> <526F09B8.9030202@asianux.com> <526F11C0.1030809@asianux.com> <526F149A.3000306@asianux.com>
In-Reply-To: <526F149A.3000306@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 07:21 AM, Chen Gang wrote:
> For some assemblers, they use another character as newline in a macro
> (e.g. arc uses '`'), so for generic assembly code, need use ASM_NL (a
> macro) instead of ';' for it.
> 
> Also need notice about code styles ('\t' for each line).
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/arc/include/asm/linkage.h |    2 ++
>  include/linux/linkage.h        |   19 ++++++++++++-------

Acked-by: Vineet Gupta <vgupta@synopsys.com>

-Vineet
