Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbaDNMAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 08:00:45 -0400
Received: from dehamd003.servertools24.de ([31.47.254.18]:35272 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752370AbaDNMAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 08:00:44 -0400
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <534BCDE8.1090202@ladisch.de>
Date: Mon, 14 Apr 2014 14:00:40 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Li, Zhen-Hua" <zhen-hual@hp.com>, Takashi Iwai <tiwai@suse.de>
CC: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] driver/snd: es18xx driver should use udelay error
References: <1397468588-18559-1-git-send-email-zhen-hual@hp.com>
In-Reply-To: <1397468588-18559-1-git-send-email-zhen-hual@hp.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li, Zhen-Hua wrote:
> udelay with more than 20000 may cause __bad_udelay.
> Use mdelay for instead.
>
>  #ifdef AVOID_POPS
>  		/* Avoid pops */
> -                udelay(100000);
> +		mudelay(100);

This will not compile.  Please test with AVOID_POPS enabled.


Regards,
Clemens
