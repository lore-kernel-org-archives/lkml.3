Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab3CGNly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 08:41:54 -0500
Received: from momout1-smtp.messagingengine.com ([66.111.4.229]:44057 "EHLO
	momout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753586Ab3CGNlx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 08:41:53 -0500
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Mar 2013 08:41:53 EST
Message-Id: <1362663176.11919.140661201212753.170BABA0@webmail.messagingengine.com>
X-Sasl-Enc: Jfw2nICISRfVF5VVWS5b1BlBYRAqr4S1gu6aChA9p748 1362663176
From: =?UTF-8?Q?K=C3=A9vin=20THIERRY?= <kevinthierry@myopera.com>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
X-Mailer: MessagingEngine.com Webmail Interface - ajax-a334e93d
Subject: Unable to activate WiFi p2p / WiFi Direct
Date: Thu, 07 Mar 2013 13:32:56 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I've been unable to activate the p2p feature on my WiFi dongle (which
otherwise works fine). 
iwpriv command returns "wlan1 no private ioctls."
I'm running Ubuntu 12.04 with kernel 3.5.0-25 and the WiFi dongle is a
Netgear model wna1000m (driver rtl8192cu).
I've also tried with kernel 3.8.2 with the same result.
Thanks,

Kévin THIERRY
