Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762098Ab3EBVmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 17:42:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:54362 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3EBVmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 17:42:16 -0400
Message-ID: <5182DD99.7070808@infradead.org>
Date: Thu, 02 May 2013 14:41:45 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Platform Driver <platform-driver-x86@vger.kernel.org>
Subject: Re: linux-next: Tree for May 2 (platform/x86/toshiba_acpi)
References: <20130502173537.c8aa671a1b22abe2ec341b87@canb.auug.org.au>
In-Reply-To: <20130502173537.c8aa671a1b22abe2ec341b87@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/13 00:35, Stephen Rothwell wrote:
> Hi all,
> 
> Please do not add any v3.11 destined work to your linux-next included
> branches until after v3.10-rc1 is released.
> 
> Changes since 20130501:
> 

when TOSHIBA_ACPI=y and SERIO_I8042=m:

drivers/built-in.o: In function `toshiba_acpi_remove':
toshiba_acpi.c:(.text+0x29827a): undefined reference to `i8042_remove_filter'
drivers/built-in.o: In function `toshiba_acpi_add':
toshiba_acpi.c:(.text+0x298b8c): undefined reference to `i8042_install_filter'
toshiba_acpi.c:(.text+0x298c3b): undefined reference to `i8042_remove_filter'


-- 
~Randy
