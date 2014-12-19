Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaLSJNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 04:13:54 -0500
Received: from down.free-electrons.com ([37.187.137.238]:50978 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751230AbaLSJNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 04:13:52 -0500
Date: Fri, 19 Dec 2014 10:13:50 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Alexander Stein <alexanders83@web.de>
Cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] ALSA: atmel: fix building the ac97 driver for
 at91-multiplatform
Message-ID: <20141219091350.GO4885@piout.net>
References: <1418944390-27719-1-git-send-email-alexandre.belloni@free-electrons.com>
 <27289342.ORBlKX4LWa@kongar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27289342.ORBlKX4LWa@kongar>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 19/12/2014 at 09:20:47 +0100, Alexander Stein wrote :
> I recently send 3 patches to make DT working with this driver, you were on CC :). Please refer to http://comments.gmane.org/gmane.linux.alsa.devel/131686
> I wonder though why all 3 are listed there although they were sent to different lists.
> 
I know, my plan was to review them today. Maybe we could change the
commit log if your patches are taken before that one. I must admit I
simply kept what Arnd had written.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
