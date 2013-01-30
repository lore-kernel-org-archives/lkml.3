Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab3A3TUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 14:20:22 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:33138 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756689Ab3A3TUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 14:20:20 -0500
Date: Wed, 30 Jan 2013 20:20:18 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Takahisa Tanaka <mc74hc00@gmail.com>
Cc: linux-watchdog@vger.kernel.org,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        Arkadiusz Miskiewicz <arekm@maven.pl>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-kernel@vger.kernel.org,
        Florian Mickler <florian@mickler.org>
Subject: Re: [PATCH 2/2] sp5100_tco: Write back the original value to reserved bits, instead of zero
Message-ID: <20130130192018.GB20100@spo001.leaseweb.com>
References: <1358128918-4415-1-git-send-email-mc74hc00@gmail.com> <1358128918-4415-2-git-send-email-mc74hc00@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358128918-4415-2-git-send-email-mc74hc00@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> In case of SP5100 or SB7x0 chipsets, the sp5100_tco module writes zero to
> reserved bits. The module, however, shouldn't depend on specific default
> value, and should perform a read-merge-write operation for the reserved
> bits.
> 
> This patch makes the sp5100_tco module perform a read-merge-write operation
> on all the chipset (sp5100, sb7x0, sb8x0 or later).
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43176
> Signed-off-by: Takahisa Tanaka <mc74hc00@gmail.com>

Added to linux-watchdog-next.

Kind regards,
Wim.

