Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668Ab3LAAyA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 19:54:00 -0500
Received: from foo.stuge.se ([212.116.89.98]:45112 "EHLO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab3LAAx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 19:53:58 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Nov 2013 19:53:57 EST
Message-ID: <20131201004715.11125.qmail@stuge.se>
Date: Sun, 1 Dec 2013 01:47:15 +0100
From: Peter Stuge <peter@stuge.se>
To: Michal Nazarewicz <mpn@google.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Eugene Krasnikov <k.eugene.e@gmail.com>, ath9k-devel@venema.h4ckr.net,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ath9k-devel] [PATCH] net: wireless: wcn36xx: fix potential
	NULL pointer dereference
Mail-Followup-To: Michal Nazarewicz <mpn@google.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Eugene Krasnikov <k.eugene.e@gmail.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1385744870-10164-1-git-send-email-mpn@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385744870-10164-1-git-send-email-mpn@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Nazarewicz wrote:
> +			wcn36xx_err("Run out of memory while hnadling SMD_EVENT (%d)\n",
> +				    msg_header->msg_type);

Typo hnadling.


//Peter
