Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaLSRCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 12:02:24 -0500
Received: from down.free-electrons.com ([37.187.137.238]:52951 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751156AbaLSRCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 12:02:23 -0500
Date: Fri, 19 Dec 2014 18:02:21 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Alexander Stein <alexanders83@web.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ALSA: atmel: fix building the ac97 driver for
 at91-multiplatform
Message-ID: <20141219170221.GU4885@piout.net>
References: <1418944390-27719-1-git-send-email-alexandre.belloni@free-electrons.com>
 <54943BF8.4050008@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54943BF8.4050008@cogentembedded.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

On 19/12/2014 at 17:53:44 +0300, Sergei Shtylyov wrote :
> >+#define cpu_is_at32ap7000() (0)
> 
>    () around 0 not needed at all.
> 

Do you want me to fix that and resubmit? I don't have strong opinion
about this.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
