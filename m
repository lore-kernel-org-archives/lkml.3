Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbbAVMmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 07:42:11 -0500
Received: from forward-corp1m.cmail.yandex.net ([5.255.216.100]:42717 "EHLO
	forward-corp1m.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752625AbbAVMmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 07:42:07 -0500
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jan 2015 07:42:07 EST
Authentication-Results: smtpcorp1m.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Thu, 22 Jan 2015 15:35:55 +0300
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: vigneshr@codeaurora.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, viresh.kumar@linaro.org, fweisbec@gmail.com,
        mingo@kernel.org, cl@linux.com, psodagud@codeaurora.org,
        sboyd@codeaurora.org
Subject: Re: [PATCH v3] hrtimers: calculate expires_next after all timers are
 executed
Message-ID: <20150122123555.GA2949@ya.yandex.net>
References: <5575911c82b96b23fdcaeb71bde87e9e.squirrel@www.codeaurora.org>
 <alpine.DEB.2.11.1501221144210.5526@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501221144210.5526@nanos>
User-Agent: Mutt/1.5.22 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Slightly tested your version (with Vignesh's fixes), no issues so far, thanks!
