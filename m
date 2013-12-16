Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab3LPMi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:38:26 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:41133 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab3LPMiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:38:24 -0500
Message-ID: <1387197495.4665.16.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix TX device statistics for monitor
 interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Gnedt <david.gnedt@davizone.at>
Date: Mon, 16 Dec 2013 13:38:15 +0100
In-Reply-To: <1386492357-20826-1-git-send-email-pali.rohar@gmail.com> (sfid-20131208_094635_923822_94E0BD99)
References: <87iowiszyu.fsf@purkki.adurom.net>
	 <1386492357-20826-1-git-send-email-pali.rohar@gmail.com>
	 (sfid-20131208_094635_923822_94E0BD99)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-08 at 09:45 +0100, Pali Rohár wrote:
> From: David Gnedt <david.gnedt@davizone.at>
> 
> Count TX packets and bytes also for monitor interfaces.

> +	dev->stats.tx_packets++;
> +	dev->stats.tx_bytes += skb->len;
> +
>  	/*
>  	 * fix up the pointers accounting for the radiotap
>  	 * header still being in there.  We are being given

Should we really count the machine-local radiotap management stuff?

johannes

