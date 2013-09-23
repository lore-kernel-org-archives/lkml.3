Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab3IWXIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 19:08:37 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:33553 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab3IWXIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 19:08:35 -0400
Message-ID: <5240C9EF.7030008@converseincode.com>
Date: Mon, 23 Sep 2013 19:08:31 -0400
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: charlebm@gmail.com, balbi@ti.com
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: Re: [PATCH] usb: LLVMLinux: Remove VLAIS from USB gadget
References: <1379976833-20859-1-git-send-email-charlebm@gmail.com>
In-Reply-To: <1379976833-20859-1-git-send-email-charlebm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/13 18:53, charlebm@gmail.com wrote:
> From: Mark Charlebois <charlebm@gmail.com>
>
>
> The use of variable length arrays in structs (VLAIS) in the Linux Kernel code
> precludes the use of compilers which don't implement VLAIS (for instance the
> Clang compiler). This patch removes the use of VLAIS in the gadget driver.
>
> This version has been tested to compile cleanly.
>
> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> Signed-off-by: Behan Webster <behanw@converseincode.com>
>
This is the fixed patch which was sent to Andrzej Pietrasiewicz.

Behan

-- 
Behan Webster
behanw@converseincode.com

