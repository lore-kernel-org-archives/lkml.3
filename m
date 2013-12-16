Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab3LPLni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 06:43:38 -0500
Received: from smtp.sgsi.ucl.ac.be ([130.104.5.67]:45153 "EHLO
	smtp6.sgsi.ucl.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab3LPLnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 06:43:37 -0500
X-Greylist: delayed 499 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Dec 2013 06:43:37 EST
X-DKIM: Sendmail DKIM Filter v2.8.3 smtp6.sgsi.ucl.ac.be 25E581C579F
Date: Mon, 16 Dec 2013 12:35:10 +0100
From: Christoph Paasch <christoph.paasch@uclouvain.be>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>, ianfang.cn@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: BUG: crashkernel does not boot upon crash from sysrq-trigger
Message-ID: <20131216113510.GA5211@cpaasch-mac>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Sgsi-Spamcheck: SASL authenticated, 
X-SGSI-MailScanner-ID: 25E581C579F.A0541
X-SGSI-MailScanner: Found to be clean
X-SGSI-From: christoph.paasch@uclouvain.be
X-SGSI-Spam-Status: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

since 3.5, my crashkernel does not boot anymore when triggering an oops with
/proc/sysrq-trigger on my HP Elitebook 8540p.

I bisected it down to 722bc6b16771ed8 (x86/mm: Fix the size calculation of
mapping tables).


Does anybody has an idea what is going wrong here?
Let me know, if I should provide more information.


Thanks,
Christoph

