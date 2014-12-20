Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaLTUV7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 15:21:59 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:62128 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaLTUV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 15:21:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>,
        Alexander Stein <alexanders83@web.de>
Subject: Re: [PATCH] ALSA: atmel: fix building the ac97 driver for at91-multiplatform
Date: Sat, 20 Dec 2014 21:21:10 +0100
Message-ID: <1638172.tTanQ3d90c@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141219170221.GU4885@piout.net>
References: <1418944390-27719-1-git-send-email-alexandre.belloni@free-electrons.com> <54943BF8.4050008@cogentembedded.com> <20141219170221.GU4885@piout.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:DLUC5G8S3Nw1/g+MIcNHn26wET65+MeQ87J4+sEizofTqi0t1rA
 kIXyYZgh9V41jqBGtN2UJbvlzlbZ7O7SpS+n9q0jI9o6ZOngDwuI8TPcI1agJmx24xnIpG8
 l/VC8chd5rd5Ul9s/SweuQqHgKDZY9BUz81GePBQ1dJpy/FtdXSEfhUjH73BZXU1eEc54/p
 UiWOah3zZEHHBZmZhqttg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 December 2014 18:02:21 Alexandre Belloni wrote:
> Arnd,
> 
> On 19/12/2014 at 17:53:44 +0300, Sergei Shtylyov wrote :
> > >+#define cpu_is_at32ap7000() (0)
> > 
> >    () around 0 not needed at all.
> > 
> 
> Do you want me to fix that and resubmit? I don't have strong opinion
> about this.

Yes, no point debating over this. I copied the definition from
arch/arm/mach-at91/include/mach/cpu.h and didn't want to do any
style changes, otherwise I'd probably have turned it into an
inline function, but any version that works is fine with me.

	Arnd
