Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab3LELCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:02:18 -0500
Received: from gloria.sntech.de ([95.129.55.99]:51299 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754675Ab3LELCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:02:12 -0500
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [REPOST PATCH V2] irq: enable all irqs unconditionally in irq_resume
Date: Thu, 5 Dec 2013 12:01:58 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>, Stephen Warren <swarren@wwwdotorg.org>
References: <1385388587-16442-1-git-send-email-ldewangan@nvidia.com> <52A05A21.5070100@nvidia.com>
In-Reply-To: <52A05A21.5070100@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312051201.59284.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

Am Donnerstag, 5. Dezember 2013, 11:49:05 schrieb Laxman Dewangan:
> Can you please review this patch?
> This patch is pending from long back for review.

the patch already made it into the appropriate tree, as can be seen by tip-bot
message and on [0].


Heiko

[0] http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?h=irq-urgent-for-linus&id=ac01810c9d2814238f08a227062e66a35a0e1ea2
