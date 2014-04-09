Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933758AbaDISBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 14:01:10 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:32790 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741AbaDISBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 14:01:06 -0400
X-Sasl-enc: aH0aNONHsWE0tZIH0olWlexsQN4no0NIPe3z3OKD7jVt 1397066460
Date: Wed, 9 Apr 2014 15:00:49 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Julian Andres Klode <jak@jak-linux.org>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "open list:THINKPAD ACPI EXT..." 
	<ibm-acpi-devel@lists.sourceforge.net>,
        "open list:THINKPAD ACPI EXT..." 
	<platform-driver-x86@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [ibm-acpi-devel] [PATCH 1/4] thinkpad_acpi: Add support for
 controlling charge thresholds
Message-ID: <20140409180048.GA22476@khazad-dum.debian.net>
References: <1384178195-12218-1-git-send-email-jak@jak-linux.org>
 <1384178195-12218-2-git-send-email-jak@jak-linux.org>
 <20131230132915.GB24241@jak-x230>
 <20131230215843.GB4938@khazad-dum.debian.net>
 <20131230224045.GC4938@khazad-dum.debian.net>
 <20131231000115.GA28120@jak-x230>
 <20131231121231.GB25729@khazad-dum.debian.net>
 <20131231224605.GA32669@jak-x230>
 <20140406121456.GA8980@jak-x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140406121456.GA8980@jak-x230>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 06 Apr 2014, Julian Andres Klode wrote:
> OK, tommorow is now, 4 months later. I was to busy with
> lectures. An updated patch is below that passes my small
> test suite.
> 
> The next step is to integrate this properly with power supply
> and/or acpi battery. One way would be to add additional power
> supply properties and then add get/set_property() pointers to
> the acpi battery which it can fall back to if it does not support
> a requested property (and we would locate the ACPI battery and
> set those pointers to new thinkpad_acpi functions).

Well, when you feel it is ready enough, please send a new version of the
entire changeset, with all changes (and label it v2 or something).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
