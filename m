Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab3CLIdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 04:33:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42276 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab3CLIdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 04:33:13 -0400
Message-ID: <513EE805.6040509@ti.com>
Date: Tue, 12 Mar 2013 09:32:05 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130301 Thunderbird/17.0.3
MIME-Version: 1.0
To: Silviu Popescu <silviupopescu1990@gmail.com>
CC: <linux-omap@vger.kernel.org>, <jarkko.nikula@bitmer.com>,
        <lgirdwood@gmail.com>, <broonie@opensource.wolfsonmicro.com>,
        <perex@perex.cz>, <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] omap: convert to devm_ioremap_resource()
References: <1363017537-11602-1-git-send-email-silviupopescu1990@gmail.com> <513EE454.5040302@ti.com> <CAPWTe+K1E1Tm1E2B_rnj9x9hvCcUXgi2hg-DQNWHO3uZaVt+Pg@mail.gmail.com>
In-Reply-To: <CAPWTe+K1E1Tm1E2B_rnj9x9hvCcUXgi2hg-DQNWHO3uZaVt+Pg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2013 09:24 AM, Silviu Popescu wrote:
> As far as I can tell from the mails that you have provided, those
> patches replace devm_request_mem_region(), followed by devm_ioremap()
> with devm_request_and_ioremap().
> What this patch attempts to do is replace devm_request_and_ioremap()
> with the newly introduced devm_ioremap_resource(), for the reasons
> expressed in the patch body.

Ah, true.

-- 
Péter
