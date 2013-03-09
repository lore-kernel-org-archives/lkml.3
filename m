Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab3CIVk3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 16:40:29 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49246 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751430Ab3CIVk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 16:40:28 -0500
X-Sasl-enc: naeNA6Qe9UJyVdr/BtbLjLpfguzp8zSbJQci05orWZrJ 1362865227
Date: Sat, 9 Mar 2013 18:40:25 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Zdenek Kabelac <zkabelac@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        joe@perches.com, isimatu.yasuaki@jp.fujitsu.com,
        rafael.j.wysocki@intel.com
Subject: Re: ACPI undocking on 3.8-rc5 no longer works with Lenovo T61
Message-ID: <20130309214025.GC7559@khazad-dum.debian.net>
References: <5107A899.9080109@redhat.com>
 <51390B2B.6070500@redhat.com>
 <1362695426.12845.144.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362695426.12845.144.camel@misato.fc.hp.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Mar 2013, Toshi Kani wrote:
> dock.0 on your Lenovo likely shows as "battery_bay", which I think you
> cannot undock regardless of this patch.  Can you try to undock the one

You're supposed to be able to undock any thinkpad battery just fine, and it
used to work on older firmware such as the one in the T61.  If this is
broken, some other bugs may be at play.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
