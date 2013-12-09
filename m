Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633Ab3LISos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 13:44:48 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:40227 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251Ab3LISor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 13:44:47 -0500
Message-ID: <1386614681.7152.189.camel@host5.omatika.ru>
Subject: Re: [PATCH 0/9] ARM: support for ICP DAS LP-8x4x (with dts)
From: Sergei Ianovich <ynvich@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Mack <zonque@gmail.com>
Date: Mon, 09 Dec 2013 22:44:41 +0400
In-Reply-To: <201312090251.45207.arnd@arndb.de>
References: <1386348542-9584-1-git-send-email-ynvich@gmail.com>
	 <1386543229-1542-1-git-send-email-ynvich@gmail.com>
	 <201312090251.45207.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-09 at 02:51 +0100, Arnd Bergmann wrote:
> On Sunday 08 December 2013, Sergei Ianovich wrote:
> > 
> > Except for defconfig, this is a completely new series. The first
> > eight patches fix outstanding issues with device tree support
> > in PXA. The 9th boots ICP DAS LP-8x4x.
> 
> Awesome! That was very quick. The main comment I have is for the
> dmaengine support, you will need to rebase on Daniel's patches for
> that. I also found few minor details.

Thanks for review.

I've applied and tested changes to meet review remarks for all patches,
except 5/9. However, there is no point to respin the series until the
decision about DMA is made.

Daniel, could please CC me when you post update pxa-dma series?


