Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab3CKVA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:00:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62648 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab3CKVAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:00:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/4][V2] time : set broadcast irq affinity
Date: Mon, 11 Mar 2013 21:00:43 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, john.stultz@linaro.org,
        viresh.kumar@linaro.org, jacob.jun.pan@linux.intel.com,
        LAK <linux-arm-kernel@lists.infradead.org>, santosh.shilimkar@ti.com,
        linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        rickard.andersson@stericsson.com, vincent.guittot@linaro.org,
        linus.walleij@stericsson.com
References: <1362219013-18173-1-git-send-email-daniel.lezcano@linaro.org> <51396B39.3090504@linaro.org> <alpine.LFD.2.02.1303080817230.22263@ionos>
In-Reply-To: <alpine.LFD.2.02.1303080817230.22263@ionos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303112100.43543.arnd@arndb.de>
X-Provags-ID: V02:K0:/DaEKnjS8ED71Ka9AjslAJrff/5faV1cJ6TCBPxEALa
 rO+7Z3NUzJ6XTPKNQwzyMCiyx6KKL9ahnAX8nJmf1F2EFZEVt8
 XTqb3T8mFOjwX5O2cwZtHSrqe5YtCoobNAUC1i6K6H4Ai+vt9c
 mIYRKJfJ164/83U93BSBz8aSkPuNO6/TwryQ6yG2ZoDzSuoFMc
 hEAA1TDrzTzTkr7KolkRYotQ4asHMd4SwJdfXDHdUoH1LSavhA
 u/ze6WUJawpbq/DQRJKApBO3FMHg/U4x11HDS3YhZgTOndqmRU
 jg23fxnqyESk3alpkLJ+oj8Kd6Hr4KLz2NSoD7NbRfTeX+UqeE
 B3LsPdsN8jF8DdAh7XPQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 March 2013, Thomas Gleixner wrote:
> On Fri, 8 Mar 2013, Daniel Lezcano wrote:
> > On 03/06/2013 10:48 AM, Thomas Gleixner wrote:
> > I was wondering if it would be possible to take the 3/4 and 4/4
> > otherwise the flag dependency will prevent to send those to the
> > maintainer's tree until they gain visibility on it.
> 
> I can take them with the ack of arm soc folks.

Sounds good,

Acked-by: Arnd Bergmann <arnd@arndb.de>
