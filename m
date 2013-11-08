Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab3KHOkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 09:40:36 -0500
Received: from mout.web.de ([212.227.17.12]:54066 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab3KHOkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 09:40:35 -0500
Message-ID: <527CF7DA.6010709@web.de>
Date: Fri, 08 Nov 2013 15:40:26 +0100
From: Markus Elfring <Markus.Elfring@web.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: reserved identifier violation
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:ySP9mTTqlFSGeDRVGLa7PQt7ETlulgrbkvo76+HoSjfdl2Ac20g
 ZX+HOtdyOljLmv4YAE+Qg7Qr3kjNtSihGhOMAihyWQCxCil9UYF0bxMwfFCivVI8YUPJzc3
 ME2J+ssxOMIIfb1oBDu0fldILR4K8EN5LkjdtlygvGdk0G2TOX37eqNjTaM6uhXOF0k3Zdb
 flEFgCroPn9K9gaFBQd0Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I find that identifiers like the following do not fit to the expected naming
convention of the C language standard.
- _ALPHA_BUG_H

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/arch/alpha/include/asm/bug.h?id=acadbfb90a54673d6c8b05aa4e93218433890411#n1

- __BARRIER_H

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/arch/alpha/include/asm/barrier.h?id=77b4cf5cb0c9d6010a18030a0e0a8d2aaf6b43ec#n1

- _UAPI__ALPHA_COMPILER_H

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/arch/alpha/include/uapi/asm/compiler.h?id=96433f6ee49032d7a8bda76de2b05cfde2914354#n1


Would you like to adjust the selection for unique names?
https://www.securecoding.cert.org/confluence/display/seccode/DCL37-C.+Do+not+declare+or+define+a+reserved+identifier#DCL37-C.Donotdeclareordefineareservedidentifier-NoncompliantCodeExample%28HeaderGuard%29

Regards,
Markus
