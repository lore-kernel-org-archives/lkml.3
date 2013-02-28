Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772Ab3B1R2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 12:28:47 -0500
Received: from mail.pr.hu ([87.242.0.5]:34230 "EHLO mail.pr.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587Ab3B1R2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 12:28:45 -0500
Message-ID: <512F93C2.7050105@pr.hu>
Date: Thu, 28 Feb 2013 18:28:34 +0100
From: Boszormenyi Zoltan <zboszor@pr.hu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Azat Khuzhin <dohardgopro@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: loadavg question
References: <512F4716.4050802@pr.hu> <CAAW1UO8b5gc5fD++XTvE8y1yF6N-j7LoiGnQZFzgo-3robe+zQ@mail.gmail.com>
In-Reply-To: <CAAW1UO8b5gc5fD++XTvE8y1yF6N-j7LoiGnQZFzgo-3robe+zQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.0 (--)
X-Scan-Signature: 2e5eb630a1ec22e7814fe1e7a9c849de
X-Spam-Tracer: backend.mail.pr.hu -2.0 20130228172703Z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

yes, that commit is in my kernel 3.7.9 kernel source, but not in 3.3.2.
Also, I have CONFIG_NO_HZ=n in my .config. I will retry with
CONFIG_NO_HZ=y with 3.7.9.

Thanks,
Zoltán Böszörményi

2013-02-28 15:05 keltezÃ©ssel, Azat Khuzhin Ã­rta:
>
> Hi,
>
> Could you check do you have commit that mentioned here?
> http://comments.gmane.org/gmane.linux.kernel/1346108
>
> Respectfully
> Azat Khuzhin.
> >From phone.
>
> On Feb 28, 2013 4:40 PM, "Boszormenyi Zoltan" <zboszor@pr.hu <mailto:zboszor@pr.hu>> wrote:
>
>     Hi,
>
>     on an embedded PC (500MHz AMD Geode), we recently tried
>     to upgrade the kernel. The original version was 2.6.27, the new
>     ones were 3.3.x and 3.7.x. With the same userspace (a GTK based
>     GUI constantly querying daemons handling different pieces of
>     hardware over serial ports), we noticed that loadavg is different
>     while the idle time (95-97%) is the same. On 2.6.27, the load was
>     around 0.05-0.3 while on 3.3.x and 3.7.x, it quickly crawled up
>     to around 5. Has the load calculation changed so dramatically
>     after 2.6.27?
>
>     Thanks in advance,
>     ZoltÃ¡n BÃ¶szÃ¶rmÃ©nyi
>
>     --
>     To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>     the body of a message to majordomo@vger.kernel.org <mailto:majordomo@vger.kernel.org>
>     More majordomo info at Â http://vger.kernel.org/majordomo-info.html
>     Please read the FAQ at Â http://www.tux.org/lkml/
>

