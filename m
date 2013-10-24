Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab3JXQdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 12:33:09 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35433 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755507Ab3JXQdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 12:33:07 -0400
X-Sasl-enc: xKPauElCVXViQR1idZB+kclxGGgV+SU8gQ1M1dSFftlb 1382632385
Date: Thu, 24 Oct 2013 14:33:02 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Takashi Iwai <tiwai@suse.de>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad_acpi: Fix build error when CONFIG_SND_MAX_CARDS
 > 32
Message-ID: <20131024163302.GA3851@khazad-dum.debian.net>
References: <1382623592-31690-1-git-send-email-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382623592-31690-1-git-send-email-tiwai@suse.de>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Oct 2013, Takashi Iwai wrote:
> SNDRV_CARDS can be specified via Kconfig since 3.11 kernel, so this
> can be over 32bit integer range, which leads to a build error.
> 
> Cc: <stable@vger.kernel.org> [v3.11+]
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
