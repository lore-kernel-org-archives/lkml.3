Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364Ab3D2Qwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:52:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:39785 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757537Ab3D2Qwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:52:32 -0400
Message-ID: <517EA507.203@infradead.org>
Date: Mon, 29 Apr 2013 09:51:19 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa <alsa-devel@alsa-project.org>
Subject: Re: linux-next: Tree for Apr 29 (sound/soc)
References: <20130429191754.8ee71fb814790bf345516ab8@canb.auug.org.au>
In-Reply-To: <20130429191754.8ee71fb814790bf345516ab8@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/13 02:17, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130426:
> 


on i386:

CONFIG_I2C=m

sound/built-in.o: In function `snd_soc_codec_set_cache_io':
(.text+0x1ebe4): undefined reference to `regmap_init_i2c'
make[1]: *** [vmlinux] Error 1



-- 
~Randy
