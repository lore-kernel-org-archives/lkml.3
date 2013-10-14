Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3JNIGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:06:09 -0400
Received: from mail-a04.ithnet.com ([217.64.83.99]:36947 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752066Ab3JNIGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:06:07 -0400
X-Sender-Authentication: SMTP AUTH verified <skraw>
Date: Mon, 14 Oct 2013 10:06:03 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: linux-kernel@vger.kernel.org
Subject: fstrim with raid controllers
Message-Id: <20131014100603.722ca616.skraw@ithnet.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 3.1.2 (GTK+ 2.24.18; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

since SSDs are pretty widespread now the question seems valid. We have some
raid controllers, namely:

RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 2208 [Thunderbolt]
(rev 05)

We would like to use SSDs for raid1/5/6 setups but found out that the drivers
don't seem to support the trim command yet.
Are there any ideas how to make that work, or are there any other controllers
that already support this?

-- 
Regards,
Stephan
