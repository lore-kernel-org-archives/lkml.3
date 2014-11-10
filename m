Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaKJPZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:25:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42910 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985AbaKJPZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:25:44 -0500
Message-ID: <5460D8F4.9000507@suse.de>
Date: Mon, 10 Nov 2014 15:25:40 +0000
From: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg
Subject: Re: dtb size limit? was Re: Tiny dts change breaks boot on n900
References: <20141110123118.GA31134@amd> <20141110125806.GA16650@amd>
In-Reply-To: <20141110125806.GA16650@amd>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.11.2014 um 12:58 schrieb Pavel Machek:
> If I replace the blo[ck] below with
> 
>  a = <1>;
>  b = <2>;
>  c = <3>;
>  d = <4>;
> 
> Resulting kernel boots. Replacing it with
> 
>  a-really-long-attribute-name-hopefully-this-breaks-stuff = <1>;
>  b = <2>;
>  c = <3>;
>  d = <4>;
> 
> Breaks the boot. I'm using dtb append option. Any ideas? Nonbooting
> dtb is 68910 bytes.

Did you verify that your initrd, if any, does not overlap the end of the
kernel when loading it from the bootloader?

Andreas

-- 
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 21284 AG Nürnberg
