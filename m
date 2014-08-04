Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaHDHWC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 03:22:02 -0400
Received: from dehamd003.servertools24.de ([31.47.254.18]:58308 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750986AbaHDHWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 03:22:00 -0400
Message-ID: <53DF345A.3000205@ladisch.de>
Date: Mon, 04 Aug 2014 09:20:58 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64;
	rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Hans Wennborg <hans@hanshq.net>
CC: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/19] alsa: riptide: fix %d confusingly prefixed with
	0x in format strings
References: <1407111685-15351-1-git-send-email-hans@hanshq.net>
In-Reply-To: <1407111685-15351-1-git-send-email-hans@hanshq.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <20140804072002.880949.17637@dehamd003.servertools24.de>
X-PPP-Vhost: ladisch.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans Wennborg wrote:
> Signed-off-by: Hans Wennborg <hans@hanshq.net>
> ---
>  sound/firewire/fireworks/fireworks_proc.c | 4 ++--
>  sound/pci/riptide/riptide.c               | 4 ++--

The fireworks patch got split.


Regards,
Clemens
