Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583Ab3GQQ22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:28:28 -0400
Received: from a9-70.smtp-out.amazonses.com ([54.240.9.70]:41511 "EHLO
	a9-70.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756551Ab3GQQ21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:28:27 -0400
Date: Wed, 17 Jul 2013 16:28:25 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: Pekka Enberg <penberg@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH] slub: don't use cpu partial pages on UP
In-Reply-To: <1374072899-23900-1-git-send-email-u.kleine-koenig@pengutronix.de>
Message-ID: <0000013fed760f94-44ea733c-cd26-49a0-b0af-9faae933484b-000000@email.amazonses.com>
References: <1374072899-23900-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="376175846-214043042-1374078521=:7628"
X-SES-Outgoing: 2013.07.17-54.240.9.70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--376175846-214043042-1374078521=:7628
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 17 Jul 2013, Uwe Kleine-König wrote:

> cpu partial pages are used to avoid contention which does not exist in
> the UP case. So let SLUB_CPU_PARTIAL depend on SMP.

Acked-by: Christoph Lameter <cl@linux.com>
--376175846-214043042-1374078521=:7628--
