Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab3ARWLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 17:11:25 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:45883 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755598Ab3ARWLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 17:11:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Olivier Doucet <webmaster@ajeux.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: Performance issue since 3.2.6
Date: Fri, 18 Jan 2013 23:17:15 +0100
Message-ID: <1396763.8sOcKf8eSO@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAPPqfY0VaTRXKMvfKccZSwvmQP_9jLKse29ZsaP3SeSm+xKvBg@mail.gmail.com>
References: <CAPPqfY1-sYT8rcPoJ6BD0axq=oczq+xbGFSQj=uth4wc_cvkGw@mail.gmail.com> <2125649.yvtIPMVHz8@vostro.rjw.lan> <CAPPqfY0VaTRXKMvfKccZSwvmQP_9jLKse29ZsaP3SeSm+xKvBg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 18, 2013 10:43:45 PM Olivier Doucet wrote:
> > Olivier, may I see the kernel .config file?
> >
> > Rafael
> 
> I put it online, cause I didn't want to spam lkml with a long text file :
> https://gist.github.com/4567342

OK, thanks.

It looks like the value returned by pm_qos_request() with CONFIG_PM unset
for PM_QOS_CPU_DMA_LATENCY is not the right one.

I'll need to find out what value should be returned instead.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
