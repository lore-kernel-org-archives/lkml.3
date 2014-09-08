Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbaIHM5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 08:57:18 -0400
Received: from mx8.pku.edu.cn ([162.105.129.171]:45786 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753488AbaIHM5R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 08:57:17 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.404
Date: Mon, 8 Sep 2014 20:57:02 +0800 (CST)
From: =?gbk?B?WHVldGFvIEd1YW4g?= <gxt@pku.edu.cn>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Message-ID: <174974381.13596.1410181022043.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <540B439C.8070204@roeck-us.net>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_Re:_=E5=9B=9E=E5=A4=8D?=
 =?utf-8?Q?=EF=BC=9A_Re:_=E5=9B=9E=E5=A4=8D=EF=BC=9A_R?=
 =?utf-8?Q?e:_=E5=9B=9E=E5=A4=8D=EF=BC=9A_Re:_?=
 =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_Status_?=
 =?utf-8?Q?of_'unicore32'_architecture_in_Linux_kernel?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Guenter Roeck <linux@roeck-us.net> 写道：
> On 09/04/2014 11:13 PM, Xuetao Guan  wrote:
> Hi,
> 
> I made everything I have available at http://server.roeck-us.net/qemu/unicore32/.
> I tried multiple variants for creating the root file system, including the one
> on https://github.com/gxt/UniCore32.git and the one using mkrootfs.sh in
> the link above. No difference - I always see the same crash. Note that the
> 'init' program is loading, but crashes with above error (0x0000000b is SIGSEGV
> unless I am missing something).
> 
> Note that I used the latest qemu for unicore from upstream sources; I was unable
> to compile it from git@github.com:gxt/QEMU.git. Qemu configuration did not seem
> to make a difference. The toolchain was extracted from uc4-1.0.5-hard.tgz.
> 
> Hope this helps,
> Guenter
> 
I guess you used the newest kernel to run busybox.
However, as for unicore32, the newest kernel uses different ABI with uc4-1.0.5 toolchain.
I'm sorry to make it so confusing.
I'll update and submit another-ABI patches asap.

Thanks,
Xutao



