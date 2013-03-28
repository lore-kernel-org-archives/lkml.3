Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab3C1Kd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 06:33:27 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:35452 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab3C1Kd0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 06:33:26 -0400
From: Fabio Coatti <fabio.coatti@gmail.com>
To: =?utf-8?B?546L6YeR5rWm?= <jinpuwang@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: 3.7.10 kernel crash
Date: Thu, 28 Mar 2013 11:33:21 +0100
Message-ID: <2118676.n3dmTseAg8@calvin>
User-Agent: KMail/4.10.1 (Linux/3.8.4; KDE/4.10.1; x86_64; ; )
In-Reply-To: <CAD9gYJJL7keTNEHE0nFt6ROy2NbTTJ+=Th+tO7cj9AjygDjmVQ@mail.gmail.com>
References: <CADpTngWo_c0MHNwYEFwSR_9KQrWKrOVgQSze+rZc4Ze9Rj2hsw@mail.gmail.com> <CADpTngW8RTVX28bVJQe5tV_ccc+FNOJezeQbczXFudy+7bMRDQ@mail.gmail.com> <CAD9gYJJL7keTNEHE0nFt6ROy2NbTTJ+=Th+tO7cj9AjygDjmVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, according to kernel source the driver is 3.125 September 26, 2012 
(drivers/net/ethernet/broadcom/tg3.c) while the latest source downloadable 
from broadcom site is 3.124c Aug 14, 2012 so I guess that the driver in 
vanilla kernel is the latest available.


> In data giovedì 28 marzo 2013 11:09:50, 王金浦 ha scritto:
> 
> Hi Fabio,
> 
> 
> Have you try latest tg3 driver from Broadcom, the backtrace show the tg3 may 
the cause of the panic?
> 
> 
> Jack
> 
> 
> 2013/3/27 Fabio Coatti <fabio.coatti@gmail.com>:
> 
> > Hi all,
> > we are experiencing crashes on some servers, right now running 3.7.10;
> > I've been able to get only screenshots from dying server that I
> > attached below. Probably we can exclude hardware issues, as it
> > happened on two different servers.
> 
> 
> 
> --
> Fabio
