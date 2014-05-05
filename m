Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbaEEJcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 05:32:18 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:44792 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755578AbaEEJcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 05:32:17 -0400
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 May 2014 05:32:16 EDT
X-Yandex-Uniq: 230e22a2-f0b5-4d0b-a4c9-d5c87b94dcc8
Authentication-Results: smtpcorp1o.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Mon, 5 May 2014 13:26:55 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hrtimers: calculate expires_next after all timers are
 executed
Message-ID: <20140505092655.GA18207@stfomichev-desktop.yandex.net>
References: <1395067037-20060-1-git-send-email-stfomichev@yandex-team.ru>
 <alpine.DEB.2.02.1403191149460.18573@ionos.tec.linutronix.de>
 <20140319141615.GB11081@stfomichev-desktop.yandex.net>
 <20140324084234.GA9910@stfomichev-desktop.yandex.net>
 <4634d0375405114b95ee02e4e1d7f314@www.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4634d0375405114b95ee02e4e1d7f314@www.linutronix.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >Any comment on the v2?
> 
> I'm traveling and it's in my todo list
Ping? It's been a while since you added it to your todo list :-)

Btw, I have a couple of machines that have been working without any
issues with this patch applied...
