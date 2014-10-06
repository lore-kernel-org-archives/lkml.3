Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaJFTkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 15:40:51 -0400
Received: from dehamd003.servertools24.de ([31.47.254.18]:56657 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751213AbaJFTku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 15:40:50 -0400
Message-ID: <5432F060.5060307@ladisch.de>
Date: Mon, 06 Oct 2014 21:41:20 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64;
	rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>, Takashi Iwai <tiwai@suse.de>
CC: alsa-devel@alsa-project.org, Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] Workable vintage driver support mechanism? (Re:
	[PATCH v3] ES938 support for ES18xx driver)
References: <1412027079-15876-1-git-send-email-linux@rainbow-software.org>
	<s5h7g0dzgd5.wl-tiwai@suse.de>
	<201410061555.19007.linux@rainbow-software.org>
	<s5ha959xp53.wl-tiwai@suse.de>
	<20141006184150.GA2465@rhlx01.hs-esslingen.de>
In-Reply-To: <20141006184150.GA2465@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <20141006193955.578440.29596@dehamd003.servertools24.de>
X-PPP-Vhost: ladisch.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Mohr wrote:
> I think I have an idea which might be useful to accept:
> for every piece of sufficiently "vintage" submission,
> people would be tasked with offering (or somehow ensuring)
> a sufficiently closely time-related cleanup in other places.

The problem that such a new driver imposes is not a one-time reduction
in overall kernel quality, but the ongoing maintenance effort.


Regards,
Clemens
