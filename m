Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaL3Qmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 11:42:38 -0500
Received: from ns.lynxeye.de ([87.118.118.114]:54943 "EHLO lynxeye.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751106AbaL3Qmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 11:42:37 -0500
Message-ID: <1419957752.4082.2.camel@lynxeye.de>
Subject: Re: [PATCH 1/11] ARM: tegra: add function to control the GPU rail
 clamp
From: Lucas Stach <dev@lynxeye.de>
To: Vince Hsu <vinceh@nvidia.com>
Cc: thierry.reding@gmail.com, swarren@wwwdotorg.org, gnurou@gmail.com,
        bskeggs@redhat.com, martin.peres@free.fr, seven@nimrod-online.com,
        samuel.pitoiset@gmail.com, nouveau@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 30 Dec 2014 17:42:32 +0100
In-Reply-To: <54A0C148.6030400@nvidia.com>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
			 <1419331204-26679-2-git-send-email-vinceh@nvidia.com>
		 <1419426990.2179.7.camel@lynxeye.de> <549B7638.2010405@nvidia.com>
	 <1419539683.2165.6.camel@lynxeye.de> <54A0C148.6030400@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.8 (3.12.8-1.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 29.12.2014, 10:49 +0800 schrieb Vince Hsu:

[...]

> >> That's a read fence to assure the post of the previous writes through
> >> Tegra interconnect. (copy-paster from
> >> https://android.googlesource.com/kernel/tegra.git/+/28b107dcb3aa122de8e94e48af548140d519298f)
> > I see what it does, the question is more about why this is needed.
> > What is the Tegra interconnect? According to the TRM the Tegra contains
> > some standard AXI <-> AHB <-> APB bridges. That a read is needed to
> > assure the write is posted to the APB bus seems to imply that there is
> > some write buffering in one of those bridges. Can we get this documented
> > somewhere?
> The TRM does mention a read after the write. Check the section 32.2.2.3.
> 
Unfortunately this doesn't seem to be included in the public TRM. It
would be nice if this could be documented either in the next version of
the TRM or as a public Appnote.

Thanks,
Lucas


