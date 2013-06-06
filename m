Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab3FFEQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 00:16:14 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:37931 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab3FFEQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 00:16:13 -0400
Date: Thu, 6 Jun 2013 04:16:12 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
cc: linux-omap@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Broken DM816x support in Linux 3.10-rc4
In-Reply-To: <1370446156-11788-1-git-send-email-aida.mynzhasova@skitlab.ru>
Message-ID: <alpine.DEB.2.02.1306060414580.15042@utopia.booyaka.com>
References: <1370446156-11788-1-git-send-email-aida.mynzhasova@skitlab.ru>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

also,

On Wed, 5 Jun 2013, Aida Mynzhasova wrote:

> Aida Mynzhasova (5):
>   ARM: OMAP: AM33xx: multiple renames for early initialization

If this patch is what's responsible for all the file renaming, please drop 
it.  Looks from the change summary that it's just useless churn (although 
I haven't seen the patch here since it never made it to the lists)


- Paul
