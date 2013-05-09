Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab3EIIDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 04:03:55 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:44278 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab3EIIDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 04:03:52 -0400
Date: Thu, 9 May 2013 04:01:11 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, mchehab@redhat.com,
        Greg KH <gregkh@linuxfoundation.org>, balbi@ti.com
Message-ID: <1907813193.9461401.1368086471911.JavaMail.root@redhat.com>
In-Reply-To: <20130507132829.GD7633@pd.tnic>
References: <1732336275.8141054.1367911558572.JavaMail.root@redhat.com> <1066765392.8155999.1367913293110.JavaMail.root@redhat.com> <5188B9DE.5030009@linux.vnet.ibm.com> <20130507132829.GD7633@pd.tnic>
Subject: Re: 3.9.0: WARNING: at drivers/base/core.c:575
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF20 (Linux)/8.0.3_GA_5664)
Thread-Topic: 3.9.0: WARNING: at drivers/base/core.c:575
Thread-Index: cHbTQnfd4QmnOf1OIfWQZ79yj1jmsQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Borislav Petkov" <bp@alien8.de>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, "LKML" <linux-kernel@vger.kernel.org>, mchehab@redhat.com,
> "Greg KH" <gregkh@linuxfoundation.org>, balbi@ti.com
> Sent: Tuesday, May 7, 2013 9:28:29 PM
> Subject: Re: 3.9.0: WARNING: at drivers/base/core.c:575
> 
> On Tue, May 07, 2013 at 01:52:54PM +0530, Srivatsa S. Bhat wrote:
> > For the x86-64 case, does the patch posted here fix the issue?
> > http://marc.info/?l=linux-edac&m=136731542432210&w=2
> 
> CAI, can I have your Tested-by before I pick it up?
Sure, and the system is allocated to someone else at the moment, so
I'll test it out as soon as possible.
CAI Qian
> 
> Thanks.
> 
> --
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
> 
