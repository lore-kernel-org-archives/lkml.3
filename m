Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbaEMXyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 19:54:06 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:55247 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423AbaEMXyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 19:54:03 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
From: "Gioh Kim" <gioh.kim@lge.com>
To: "'Thierry Reding'" <thierry.reding@gmail.com>
Cc: "'Sumit Semwal'" <sumit.semwal@linaro.org>,
        "'Randy Dunlap'" <rdunlap@infradead.org>,
        <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gunho.lee@lge.com>
References: <1399895292-29520-1-git-send-email-gioh.kim@lge.com> <20140513084440.GL6754@ulmo>
In-Reply-To: <20140513084440.GL6754@ulmo>
Subject: RE: [PATCH] Documentation/dma-buf-sharing.txt: update API descriptions
Date: Wed, 14 May 2014 08:53:59 +0900
Message-ID: <001501cf6f06$9c86f190$d594d4b0$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQGsmzDXAkxZuFRyWtKFxD2OKL4+wQHhW/dam3XLa3A=
Content-Language: ko
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for advice.
I will send a fixed patch soon.

> -----Original Message-----
> From: Thierry Reding [mailto:thierry.reding@gmail.com]
> Sent: Tuesday, May 13, 2014 5:45 PM
> To: gioh.kim
> Cc: Sumit Semwal; Randy Dunlap; linux-media@vger.kernel.org; dri-devel@lists.freedesktop.org; linux-
> doc@vger.kernel.org; linux-kernel@vger.kernel.org; gunho.lee@lge.com
> Subject: Re: [PATCH] Documentation/dma-buf-sharing.txt: update API descriptions
> 
> On Mon, May 12, 2014 at 08:48:12PM +0900, gioh.kim wrote:
> > From: "gioh.kim" <gioh.kim@lge.com>
> 
> It might be good to fix your setup to make this be the same as the name
> and email used in the Signed-off-by line below.
> 
> > update some descriptions for API arguments and descriptions.
> 
> Nit: "Update" since it's the beginning of a sentence.
> 
> > Signed-off-by: Gioh Kim <gioh.kim@lge.com>
> > ---
> >  Documentation/dma-buf-sharing.txt |   10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
> > index 505e711..1ea89b8 100644
> > --- a/Documentation/dma-buf-sharing.txt
> > +++ b/Documentation/dma-buf-sharing.txt
> > @@ -56,7 +56,7 @@ The dma_buf buffer sharing API usage contains the following steps:
> >  				     size_t size, int flags,
> >  				     const char *exp_name)
> >
> > -   If this succeeds, dma_buf_export allocates a dma_buf structure, and returns a
> > +   If this succeeds, dma_buf_export_named allocates a dma_buf structure, and returns a
> 
> Perhaps reformat this so that the lines don't exceed 80 characters?
> 
> >     pointer to the same. It also associates an anonymous file with this buffer,
> >     so it can be exported. On failure to allocate the dma_buf object, it returns
> >     NULL.
> > @@ -66,7 +66,7 @@ The dma_buf buffer sharing API usage contains the following steps:
> >
> >     Exporting modules which do not wish to provide any specific name may use the
> >     helper define 'dma_buf_export()', with the same arguments as above, but
> > -   without the last argument; a __FILE__ pre-processor directive will be
> > +   without the last argument; a KBUILD_MODNAME pre-processor directive will be
> >     inserted in place of 'exp_name' instead.
> 
> This was already fixed in commit 2e33def0339c (dma-buf: update exp_name
> when using dma_buf_export()). Perhaps you should rebase this patch on
> top of the latest linux-next.
> 
> Otherwise looks good.
> 
> Thierry

