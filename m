Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaCHPnp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 10:43:45 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:55439 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaCHPno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 10:43:44 -0500
Message-ID: <1394293422.20149.56.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: next-20131218 - WARNING in qdisc_list_add
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Mirco Tischler <mt-ml@gmx.de>
Cc: Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Date: Sat, 08 Mar 2014 07:43:42 -0800
In-Reply-To: <CACGeUEgs5+L-9RAvMV45ODQnDVBLBgbfHu+0Ab5Wp1L=iDJQNg@mail.gmail.com>
References: <CACGeUEgs5+L-9RAvMV45ODQnDVBLBgbfHu+0Ab5Wp1L=iDJQNg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-08 at 11:41 +0100, Mirco Tischler wrote:

> Hi
> I can reproduce this warning reliably on 3.14-rc* (by executing tc
> qdisc add dev <dev> root  fq_codel via udev rule). The abbove patch
> fixes it.

Thanks for the heads up, I'll respin the patch formally.



