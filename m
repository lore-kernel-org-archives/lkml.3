Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab3FGUX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 16:23:58 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51047 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752746Ab3FGUX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 16:23:56 -0400
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Jun 2013 16:23:56 EDT
Message-Id: <1370636175.13515.140661241274985.19126A97@webmail.messagingengine.com>
X-Sasl-Enc: yW/r/P3n1e0X9NknTF7mbrPRWszG7ruOYt90Omcz6A3G 1370636175
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Adam Lee <adam.lee@canonical.com>,
        Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net,
        Alex Hung <alex.hung@canonical.com>, Bjorn Mork <bjorn@mork.no>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-25df3f14
In-Reply-To: <20130607150651.GA2227@adam-laptop>
References: <1370593209-21358-1-git-send-email-adam.lee@canonical.com>
 <1370593209-21358-4-git-send-email-adam.lee@canonical.com>
 <1370611358.6315.48.camel@x230.lan> <20130607150651.GA2227@adam-laptop>
Subject: Re: [PATCH 3/3] thinkpad_acpi: add LED quirks of models which don't have
 EC controllable LEDs
Date: Fri, 07 Jun 2013 17:16:15 -0300
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you get me the ACPI interface documentation?  It should be simple to get it, but I haven't emailed the Lenovo BIOS engineers for some time.

Basically, create a new LED method in thinkpad-acpi, lock it down to vendor lenovo, detect the new interfaces, and only check the two-argument LED one if the newer ones aren't found.

Not supporting the old /proc interface on new thinkpads is fine.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
