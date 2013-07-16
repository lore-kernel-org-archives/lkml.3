Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933820Ab3GPTKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:10:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58985 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933253Ab3GPTKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:10:43 -0400
Date: Tue, 16 Jul 2013 21:10:30 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: configurable partial slab support on UP
Message-ID: <20130716191030.GA31335@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(sorry for breaking the mail threading, but I failed to find the right
mail to reply to.)

while doing make oldconfig on an !SMP config using 3.11-rc1 I was asked
if I want CONFIG_SLUB_CPU_PARTIAL. AFAICT this setting only affects SMP
machines? If so I suggest to make the choice depend on SMP and treat the
!SMP case as CONFIG_SLUB_CPU_PARTIAL=n.

This was introduced in commit
	345c905 (slub: Make cpu partial slab support configurable)

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
