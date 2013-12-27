Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab3L0Tow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 14:44:52 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:59566 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab3L0Tov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 14:44:51 -0500
Date: Fri, 27 Dec 2013 20:44:47 +0100
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Subject: Re: Problem with cpufreq and i5 since post 3.9.0
Message-ID: <20131227194447.GA8188@fancy-poultry.org>
References: <20131227185924.GH17115@Blackswan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131227185924.GH17115@Blackswan>
Organization: private site
OpenPGP: id=60F4A92C; url=http://www.fritha.org/htd.asc;
 preference=signencrypt
User-Agent: Mutt/1.5.22+18 (3306cb186f49) (2013-10-16)
X-Provags-ID: V02:K0:DDAx8P9L3PwtgJUnW4dsvFZCRyTcBpxUZ+1gKxB25Fx
 rnV6Jh0b0FH04lniIZ2CBlm1Sj52ytg0L6kEw3tjMPj6Kc1r/g
 YRlMmDWhY0gECgwv7iDb4PzHz40cmxuJP8q09d/5VKJTcfIIQA
 jDEDkYqwIBQ2cSXlZiHQgQVh3mHUu2FYpvlss1U4PKMaXgxBwN
 FKlDYnXurgPJ/W67rhZfnBBv8iLcmp2mlZ9W08ObxfTUoSNEBw
 VU8R/xyw9KfZ/1eIOfCYFTLrW3ZS8XAlQJ4LlnfoNuPQb8Vkjh
 aVCq8CpMNkn63R1ggX/jyJYKiJyth8mqBt1KcBE/z59/76gfIP
 /y6GfxKkWc6PmAy+M6wJlXqIFr8ORQuOMz+Uqsn9x
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.12.2013, David Woodfall wrote: 

> But any of the newer kernel versions I've tested only give me
> performance and powersave.

I don't use any Fedora kernel, so I can't tell which governors are
enabled in those. You should check the value of "CONFIG_CPU_FREQ_GOV"
in the respective .config file for your installed kernel.

In short: It seems that only "performance" and "powersave" are
compiled in.

