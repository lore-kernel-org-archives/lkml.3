Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbaHKFKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:10:14 -0400
Received: from mx12.pku.edu.cn ([162.105.129.175]:38394 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751511AbaHKFKM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:10:12 -0400
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Aug 2014 01:10:12 EDT
X-Spam-Flag: NO
X-Spam-Score: -307.358
Date: Mon, 11 Aug 2014 13:04:07 +0800 (CST)
From: =?gbk?B?WHVldGFvIEd1YW4g?= <gxt@pku.edu.cn>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Richard Weinberger <richard@nod.at>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        linux-kernel@vger.kernel.org
Message-ID: <708311450.11684.1407733447829.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <53E79E16.7040603@roeck-us.net>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_Re:_[PATCH]_unico?=
 =?utf-8?Q?re32:_Fix_build_error?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.136]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Guenter Roeck <linux@roeck-us.net> 写道：
> On 08/10/2014 08:39 AM, Richard Weinberger wrote:
> > Guenther,
> >
> > Am 10.08.2014 17:29, schrieb Guenter Roeck:
> >> unicore32 builds fail with
> >>
> >> arch/unicore32/kernel/signal.c: In function ‘setup_frame’:
> >> arch/unicore32/kernel/signal.c:257: error:
> >> 			‘usig’ undeclared (first use in this function)
> >> arch/unicore32/kernel/signal.c:279: error:
> >> 			‘usig’ undeclared (first use in this function)
> >> arch/unicore32/kernel/signal.c: In function ‘handle_signal’:
> >> arch/unicore32/kernel/signal.c:306: warning: unused variable ‘tsk’
> >> arch/unicore32/kernel/signal.c: In function ‘do_signal’:
> >> arch/unicore32/kernel/signal.c:376: error:
> >> 			implicit declaration of function ‘get_signsl’
> >> make[1]: *** [arch/unicore32/kernel/signal.o] Error 1
> >> make: *** [arch/unicore32/kernel/signal.o] Error 2
> >>
> >> Bisect points to commit 649671c90eaf ("unicore32: Use get_signal()
> >> signal_setup_done()").
> >>
> >> This code never even compiled. Reverting the patch does not work,
> >> since previously used functions no longer exist, so try to fix it up.
> >> Compile tested only.
> >
> > Where did you get the unicore32 cross compiler from?
> >
> mprc.pku.edu.cn/~guanxuetao/linux/uc4-1.0.5-hard.tgz
> 
> Guenter

Yes, this toolchain can generate unicore32 binaries.
Thanks Guenter.

Xuetao
