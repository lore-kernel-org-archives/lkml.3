Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbaFXRSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 13:18:20 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:44540 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932077AbaFXRSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:18:18 -0400
X-Yandex-Uniq: 7dd882a4-4845-47d4-917a-d2040fa130a9
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Tue, 24 Jun 2014 21:18:07 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: john.stultz@linaro.org, prarit@redhat.com, paul.gortmaker@windriver.com,
        juri.lelli@gmail.com, ddaney.cavm@gmail.com, mbohan@codeaurora.org,
        david.vrabel@citrix.com, david.engraf@sysgo.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hrtimers: calculate expires_next after all timers are
 executed
Message-ID: <20140624171807.GA21788@stfomichev-desktop.yandex.net>
References: <1395067037-20060-1-git-send-email-stfomichev@yandex-team.ru>
 <alpine.DEB.2.02.1403191149460.18573@ionos.tec.linutronix.de>
 <20140319141615.GB11081@stfomichev-desktop.yandex.net>
 <alpine.DEB.2.10.1406221417510.5170@nanos>
 <20140623110302.GA20225@stfomichev-desktop.yandex.net>
 <alpine.DEB.2.10.1406231904090.5170@nanos>
 <20140623180443.GD20225@stfomichev-desktop.yandex.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623180443.GD20225@stfomichev-desktop.yandex.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Tested-by is fine. I can cobble a changelog together.
No issues after more than a day of running, I think you can use my

Tested-By: Stanislav Fomichev <stfomichev@yandex-team.ru>
