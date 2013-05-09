Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab3EIKR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 06:17:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34317 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522Ab3EIKR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 06:17:57 -0400
Date: Thu, 9 May 2013 12:20:48 +0200
From: Borislav Petkov <bp@alien8.de>
To: CAI Qian <caiqian@redhat.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, mchehab@redhat.com,
        Greg KH <gregkh@linuxfoundation.org>, balbi@ti.com
Subject: Re: 3.9.0: WARNING: at drivers/base/core.c:575
Message-ID: <20130509102048.GA27333@pd.tnic>
References: <1732336275.8141054.1367911558572.JavaMail.root@redhat.com>
 <1066765392.8155999.1367913293110.JavaMail.root@redhat.com>
 <5188B9DE.5030009@linux.vnet.ibm.com>
 <20130507132829.GD7633@pd.tnic>
 <1907813193.9461401.1368086471911.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1907813193.9461401.1368086471911.JavaMail.root@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 04:01:11AM -0400, CAI Qian wrote:
> Sure, and the system is allocated to someone else at the moment, so
> I'll test it out as soon as possible.

Nevermind, I was able to trigger it here too so I took it.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
