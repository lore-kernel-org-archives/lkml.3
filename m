Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab3EIKqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 06:46:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:39656 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165Ab3EIKqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 06:46:24 -0400
Message-ID: <1368096355.25488.178.camel@pasglop>
Subject: Re: 3.9.0: WARNING: at drivers/base/core.c:575
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: CAI Qian <caiqian@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>, Greg KH <gregkh@linuxfoundation.org>,
        balbi@ti.com, dyoung@redhat.com
Date: Thu, 09 May 2013 20:45:55 +1000
In-Reply-To: <518B7B6A.1090407@linux.vnet.ibm.com>
References: <1732336275.8141054.1367911558572.JavaMail.root@redhat.com>
	 <518B7B6A.1090407@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-09 at 16:03 +0530, Srivatsa S. Bhat wrote:
> Can you check if the patch posted here fixes it?
> 
> http://marc.info/?l=linux-kernel&m=136791823608013&w=2

I believe I've already merged a patch for that unless I did something
wrong ...

Cheers,
Ben.


