Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbaJ0OPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:15:07 -0400
Received: from nm2-vm9.access.bullet.mail.bf1.yahoo.com ([216.109.114.82]:45574
	"EHLO nm2-vm9.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752861AbaJ0OPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:15:03 -0400
X-Greylist: delayed 414 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Oct 2014 10:15:03 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=s1024; d=rogers.com;
	b=l/zn6i0OJLbWGd5Xa8mRyXCOvLd/0OfId9IRW0zrDOAx2vUR8IxUozdLEpONam5jNcOZyhrTyIwSroRay6tg8c4Mg7INiEMkLnVnW505u+vRVs7oEPm15Exg5gHmynrsf98Pv5pG2n3s9K1XtqyIbkMcHcwUN9T9TdJd1JbP/Og=;
X-Yahoo-Newman-Id: 861655.10852.bm@smtp119.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: oKbTlbYVM1kXGTHzZLq9Wj2qbbFMS1Dy2.ZLK2XWi97gyQB
 Lm1jGjd0JXb2ixDZTsD20.8zCNwboFYKtomPfLeaN4AyosdcrLZKtTr4nMYQ
 gzKHNmNjiHWKIW1UBOvTpcgfaDp9w1ClNWODBe668zl16MGR2LEko3vzYz2d
 xo3V3I8lK9RZzrp4Fg57JAcOBkbd1Q8Oncq89ZzZipd8sAmQqhju2EXAweUY
 C3pA2iwDO_YQJlLrNvJ_vuxq19Z6O.m4EyGK.3RurCDkVqqeM5XSlLhCyI8j
 biyrUfEEHMwlEJ6gbsp9BSPFsfoiHZMNO81WyoadhHVjHk_QVK.GQddceqLR
 ll16310HAtLdxI1zyYD44j5OJxcGyj3f28s7nZcmvZctQJK7uq7HUrmDKDZ0
 JFDHisFFGsNHVaCqVjx1D9ZbgSnrjc4rKgv52pXlycCnpDRHcjN5dzTxgcPF
 d2cx.KL.DkCww6ftKMWoGHtZbwVnHnN1vEcY9.E8q.IVv7XumOMCMEXVvSCC
 Cr3wD0MhFu0x12lzC4Y9AKSFcbAcQZRku0CmDofj9YA--
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
From: Shawn Starr <shawn.starr@rogers.com>
To: Kernel development list <linux-kernel@vger.kernel.org>
Subject: [3.18-rc1] Regression in userspace - Google Chrome
Date: Mon, 27 Oct 2014 10:08:02 -0400
Message-ID: <4344395.V0onCpLkaI@segfault>
Organization: sh0n.net
User-Agent: KMail/4.14.2 (Linux/3.17.1-303.fc21.x86_64; KDE/4.14.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello kernel folks,

In -rc1, I had problems running Google Chrome with sandbox enabled by default. 
Chrome would start once, sometimes not run at all, setuid binary would be 
stuck in 'D' state.

Using my current kernel (kernel-3.17.1-303.fc21.x86_64) no such problems 
exist.  I know 3.18 is early in it's -rc cycle but this is a heads up if 
nobody else noticed.

Now that -rc2 is out and soon Fedora will have a -rc2 kernel for me to play 
with, I'll will see if this was just noise in the merge window.

Thanks,
Shawn
