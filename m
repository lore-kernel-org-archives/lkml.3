Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab3J1NqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 09:46:20 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:34013 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab3J1NqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 09:46:01 -0400
Message-ID: <1382967954.17956.9.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 15/16] wl1251: Add sysfs file tx_mgmt_frm_rate for
 setting rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
        joni.lapilainen@gmail.com
Date: Mon, 28 Oct 2013 14:45:54 +0100
In-Reply-To: <1382819655-30430-16-git-send-email-pali.rohar@gmail.com> (sfid-20131026_224039_612331_A01681C8)
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
	 <1382819655-30430-16-git-send-email-pali.rohar@gmail.com>
	 (sfid-20131026_224039_612331_A01681C8)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-10-26 at 22:34 +0200, Pali Rohár wrote:
> This patch was extracted from Maemo 2.6.28 kernel

That's not a description or justification for the patch ....

but again, it seems like a bad idea to use sysfs.

johannes

