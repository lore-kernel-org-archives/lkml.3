Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbaIIJRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:17:18 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33832 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051AbaIIJRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:17:16 -0400
Message-ID: <540EC595.2050301@ti.com>
Date: Tue, 9 Sep 2014 14:47:09 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: <bcousson@baylibre.com>, <tony@atomide.com>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [resend PATCH 1/3] pinctrl: dra7: dt-bindings: add pin off modes
 for dra7 SoC
References: <1410203998-8700-1-git-send-email-mugunthanvnm@ti.com> <1410203998-8700-2-git-send-email-mugunthanvnm@ti.com> <20140908193235.GA12150@kahuna>
In-Reply-To: <20140908193235.GA12150@kahuna>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2014 01:02 AM, Nishanth Menon wrote:
> A) There is no OFF mode on DRA7. in sleep state use mode 15 (gated).
> B) when using this for wakeup - use pinctrl wakeup handling to do the
> wakeup.

Will drop this patch and use mode 15 in sleep mode and submit v2 patch
series

Regards
Mugunthan V N
