Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869Ab3EGN2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:28:23 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60857 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758062Ab3EGN2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:28:22 -0400
Date: Tue, 7 May 2013 15:28:29 +0200
From: Borislav Petkov <bp@alien8.de>
To: CAI Qian <caiqian@redhat.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, mchehab@redhat.com,
        Greg KH <gregkh@linuxfoundation.org>, balbi@ti.com
Subject: Re: 3.9.0: WARNING: at drivers/base/core.c:575
Message-ID: <20130507132829.GD7633@pd.tnic>
References: <1732336275.8141054.1367911558572.JavaMail.root@redhat.com>
 <1066765392.8155999.1367913293110.JavaMail.root@redhat.com>
 <5188B9DE.5030009@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5188B9DE.5030009@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 01:52:54PM +0530, Srivatsa S. Bhat wrote:
> For the x86-64 case, does the patch posted here fix the issue?
> http://marc.info/?l=linux-edac&m=136731542432210&w=2

CAI, can I have your Tested-by before I pick it up?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
