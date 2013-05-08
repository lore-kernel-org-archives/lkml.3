Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab3EHS4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:56:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55347 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab3EHSz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:55:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen GALLIMORE <stephen.gallimore@st.com>
Subject: Re: [RFC 5/8] ARM:stih41x: Add STiH415 SOC support
Date: Wed, 8 May 2013 20:55:30 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Stuart MENEFY <stuart.menefy@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com> <201305081818.01927.arnd@arndb.de> <A3BF01DB4A606149A4C20C4C4C808F6C3189E576E2@SAFEX1MAIL1.st.com>
In-Reply-To: <A3BF01DB4A606149A4C20C4C4C808F6C3189E576E2@SAFEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305082055.31081.arnd@arndb.de>
X-Provags-ID: V02:K0:0BZsL4qb0sA7DeyFEhNnSoMzsJQzcsHrZ4C9G/6DIAg
 YHHh+4R/Vq7QRKyrtNxfJ9zRo4R3EOHScsr1gxR9IgSbpXXLPJ
 tS4Qe8Tl1GuXOYi/q95HEQxf7GsnyDY2jlCpDDm5rC+mBsmfMl
 j1TRPkNWhXpHlNUBvyL7fnRm9IMX717oL0hp6IjUG0Kvgi50HJ
 Na9jul1K5o7gzRKJ5ebhYg0uM3QPQkAgWZJ7Q2jC7c1qVtHkLP
 ++J/aA/MlNZgdzQy9F7ToORORrSmxnV91AvUp8pPSrJvfLH0KU
 dvI/+OPKmK3u+wuit5Ic52I9ou11nXioa+YqhqgBk5K2NwAWKa
 9/MurY5CLD52wNBQs8wM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 May 2013, Stephen GALLIMORE wrote:

> If you have a better solution, or a way to generalize this that would
> make sense for the ARM architecture as a whole, then we are more than
> happy to change.

No idea, sorry. Upon closer inspection I wonder if your code actually
does anything to the hardware that causes it to wake up on an interrupt.

	Arnd
