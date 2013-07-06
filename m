Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab3GFOHv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 10:07:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53366 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750827Ab3GFOHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 10:07:48 -0400
X-Sasl-enc: lD5YN2/qSFxNi52gDFprQbcfSvUrnbJHI9KI1xTJRKMl 1373119666
Date: Sat, 6 Jul 2013 11:07:43 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net
Subject: Re: [PATCH 3/3] platform thinkpad: Remove deprecated
 hotkey_report_mode parameter
Message-ID: <20130706140743.GA16737@khazad-dum.debian.net>
References: <1372855719-34315-1-git-send-email-trenn@suse.de>
 <1372855719-34315-4-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372855719-34315-4-git-send-email-trenn@suse.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Jul 2013, Thomas Renninger wrote:
> It is somewhat strange that the default value to support the depracated
> interface is set (1).
> Anyway this exists for years. The previous patch already removed the
> functionality to still export specific events through /proc. Now this param
> is useless and should vanish as well.
> 
> CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Signed-off-by: Thomas Renninger <trenn@suse.de>

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
