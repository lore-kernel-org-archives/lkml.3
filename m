Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab3HWMTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:19:10 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:63875 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab3HWMTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:19:08 -0400
MIME-Version: 1.0
Date: Fri, 23 Aug 2013 17:49:08 +0530
X-Google-Sender-Auth: JUCePJo0-9eNtn3hO89G4avPvKk
Message-ID: <CAPV97yehG3qtbxCkFf_bnH30pWPkjzNwb2cmQRtUoM36oXVFuw@mail.gmail.com>
Subject: Re: [PATCH] staging: rtl8187se: Remove pt_regs * irq handler parameter
From: navin patidar <navinp@cdac.in>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        maxtram95@gmail.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On August 23, 2013 at 5:18 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Fri, Aug 23, 2013 at 05:00:06PM +0530, navin patidar wrote:
> > struct pt_regs pointer is no longer passed as a irq handler
> > argument.
> >
>
> Good eye.
>
> Could you also remove the cast to (void *) so the compiler can catch
> this in the future?
>
> - if (request_irq(dev->irq, (void *)rtl8180_interrupt, IRQF_SHARED, dev->name, dev)) {
> + if (request_irq(dev->irq, rtl8180_interrupt, IRQF_SHARED, dev->name, dev)) {
>

i will resend patch with this.

regards,
--navin-patidar
