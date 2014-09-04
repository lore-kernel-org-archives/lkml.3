Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbaIDTuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 15:50:01 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:44229 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbaIDTt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 15:49:59 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX192vZHSN4VQy/otlZvxUEER
Date: Thu, 4 Sep 2014 12:49:52 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: linux-omap@vger.kernel.org, rogerq@ti.com,
        Lokesh Vutla <lokeshvutla@ti.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] ARM: dts: dra7-evm: fixes for mux and VTT control
Message-ID: <20140904194951.GB14698@atomide.com>
References: <1409837008-32144-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409837008-32144-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [140904 06:24]:
> Hi,
> 
> The following series was inspired in part by http://marc.info/?l=linux-omap&m=140974309205295&w=2
> causing me to try and do an audit of pinctrl configurations on the platform.
> 
> Further, failures on latest board updates in the automated farm also
> caused identification of a fix which was yet to be send to upstream
> from product kernel. Slightly unrelated patches in this series.
> 
> So here they are..
> based on v3.17-rc1:
> before-dra7xx-evm:  Boot FAIL: http://paste.ubuntu.org.cn/1477597
> (fails can be at different times though.. random crashes without VTT is usual)..
> after-dra7xx-evm:  Boot PASS: http://paste.ubuntu.org.cn/1477596

Thanks applying both into omap-for-v3.17/fixes-v2.

Regards,

Tony
