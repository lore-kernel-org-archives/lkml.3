Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbaAHM5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 07:57:17 -0500
Received: from softlayer.compulab.co.il ([50.23.254.55]:54998 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbaAHM5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 07:57:15 -0500
Message-ID: <52CD4B27.2030200@compulab.co.il>
Date: Wed, 08 Jan 2014 14:57:11 +0200
From: Denis Turischev <denis.turischev@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Oliver Neukum <oneukum@suse.de>, dashing.meng@gmail.com,
        Niklas Schnelle <niklas@komani.de>, Giorgos <ganastasiouGR@gmail.com>,
        art1@vhex.net
Subject: Re: [PATCH v1] xhci: Switch Intel Lynx Point ports to EHCI on shutdown
References: <52B31EDA.60908@compulab.co.il> <52B327D5.3080805@compulab.co.il> <20131219182110.GC3573@xanatos> <52B41EC7.1070704@compulab.co.il> <20131220234547.GC2835@xanatos> <52B69925.8030409@compulab.co.il> <20140103000334.GE9621@xanatos> <52CAA2D4.2040103@compulab.co.il> <s5hd2k4qfcb.wl%tiwai@suse.de> <20140107231103.GD4199@xanatos>
In-Reply-To: <20140107231103.GD4199@xanatos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Get-Message-Sender-Via: softlayer.compulab.co.il: acl_c_relayhosts_text_entry: -unknown-@compulab.co.il|compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 01:11 AM, Sarah Sharp wrote:
> Denis, what do you mean by "works for Lynx Point"?  Do you mean that
> adding the quirk to switch the ports on EHCI on shutdown (e95829f474)
> for the Intense-PC2 *instead of* the commit to put the host in D3 on
> shutdown (638298dc66) works?  Or do you mean you need both patches for
> your system?
> 
> If you only need the quirk to switch the ports to EHCI on shutdown, then
> we could apply that broadly to Lynx Point LP, and see whether other
> BIOSes tolerate that quirk.

Yes, switching the ports on EHCI on shutdown is enough for Intense-PC2.
I don't need both patches.
