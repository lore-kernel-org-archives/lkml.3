Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab3IWIHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:07:10 -0400
Received: from us01smtp3.synopsys.com ([198.182.44.81]:62630 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab3IWIHH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:07:07 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Chen Gang <gang.chen@asianux.com>
CC: "vgupta@synopsys.com" <Vineet.Gupta1@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arc: include: asm: uaccess.h: include
 "asm-generic/uaccess-unaligned.h"
Thread-Topic: [PATCH] arc: include: asm: uaccess.h: include
 "asm-generic/uaccess-unaligned.h"
Thread-Index: AQHOt0Mgb3GioDtXqkmFohpzAwJj1g==
Date: Mon, 23 Sep 2013 08:07:02 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307514DF30@IN01WEMBXA.internal.synopsys.com>
References: <523E6274.3030602@asianux.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.239.235]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 08:53 AM, Chen Gang wrote:
> Need include the default implementation, just like another platforms
> (e.g. parisc, tile ...), or can not pass compiling.
>
> The related error (with allmodconfig for arc):
>
>     CC [M]  fs/btrfs/ioctl.o
>   fs/btrfs/ioctl.c: In function ‘btrfs_ioctl_file_extent_same’:
>   fs/btrfs/ioctl.c:2802: error: implicit declaration of function ‘__put_user_unaligned’
>
>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Acked-by: Vineet Gupta <vgupta@synopsys.com>

Thx,
-Vineet
