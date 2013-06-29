Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab3F2SrY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 14:47:24 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39675 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752383Ab3F2SrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 14:47:20 -0400
X-Sasl-enc: 8UmEEG/jSpQZcfxBno4j7LgdFpjPVRrslVvU2DsvR6zy 1372531639
Date: Sat, 29 Jun 2013 15:47:16 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Pavel Machek <pavel@ucw.cz>, Mark Lord <mlord@pobox.com>,
        Marcus Overhagen <marcus.overhagen@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        tj@kernel.org
Subject: Re: SATA hdd refuses to reallocate a sector?
Message-ID: <20130629184716.GA9330@khazad-dum.debian.net>
References: <20130623101940.GA4448@amd.pavel.ucw.cz>
 <51C76858.4060906@pobox.com>
 <20130623215100.GA7414@amd.pavel.ucw.cz>
 <201306240914.29502.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306240914.29502.linux@rainbow-software.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You know, either the "long" or the "offline" SMART test routines do exactly
that on any spinning rust device with a firmware that is not utterly broken.

The HDD's firmware will rewrite, and even reallocate any "weak" sectors
found by the surface scan.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
