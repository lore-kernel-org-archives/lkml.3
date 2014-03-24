Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaCXImp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 04:42:45 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:53791 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbaCXImo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 04:42:44 -0400
X-Yandex-Uniq: 7084bf35-be92-4712-8c44-67ceb0639b61
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Mon, 24 Mar 2014 12:42:34 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hrtimers: calculate expires_next after all timers are
 executed
Message-ID: <20140324084234.GA9910@stfomichev-desktop.yandex.net>
References: <1395067037-20060-1-git-send-email-stfomichev@yandex-team.ru>
 <alpine.DEB.2.02.1403191149460.18573@ionos.tec.linutronix.de>
 <20140319141615.GB11081@stfomichev-desktop.yandex.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140319141615.GB11081@stfomichev-desktop.yandex.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Any comment on the v2?
