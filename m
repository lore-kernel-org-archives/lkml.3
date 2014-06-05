Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaFEPWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:22:52 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:50783 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbaFEPWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:22:50 -0400
Date: Thu, 5 Jun 2014 16:22:46 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@stlinux.com,
        linux-pm@vger.kernel.org, eduardo.valentin@ti.com, rui.zhang@intel.com
Subject: Re: [STLinux Kernel] [PATCH 3/6] thermal: sti: Add support for ST's
 System Config Register based Thermal controller
Message-ID: <20140605152246.GC7446@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1401442715-6350-1-git-send-email-lee.jones@linaro.org>
 <1401442715-6350-4-git-send-email-lee.jones@linaro.org>
 <20140605151650.GB7446@griffinp-ThinkPad-X1-Carbon-2nd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140605151650.GB7446@griffinp-ThinkPad-X1-Carbon-2nd>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,


> Also a seperate somewhat unrelated question... stih415 and stih416 are very similar 
> dual die parts. Do you know why the stih415 has support for sas & mpe die temperature
> sensors, but the stih416 only has support for the sas die?

Ah I see...support for the stih416 mpe sensor is in a subsquent patch in the series.

regards,

Peter.

