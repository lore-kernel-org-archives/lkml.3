Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab3LMCdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:33:49 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:49321 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab3LMCds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:33:48 -0500
Message-ID: <1386902023.7152.290.camel@host5.omatika.ru>
Subject: Re: [PATCH v2 00/16] ARM: support for ICP DAS LP-8x4x (with dts)
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Daniel Mack <zonque@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Date: Fri, 13 Dec 2013 06:33:43 +0400
In-Reply-To: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com>
	 <1386901645-28895-1-git-send-email-ynvich@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-13 at 06:27 +0400, Sergei Ianovich wrote:
> Fixed most review requirements. Details in respective patches.
> 
> I've completely met the requirement for using dmaengine-based DMA
> in patch v2-03/16. Tests showed new DMA was underperforming. It added
> on top of a pre-existing problem with MMC bus width and made the system
> barely usable. However, the new code in this patch work correctly with
> both the existing and the new DMA. Even if the new DMA is compiled into
> the kernel, the exisitng DMA initializes first.

s/I've/I've not/

