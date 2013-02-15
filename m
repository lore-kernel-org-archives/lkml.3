Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422671Ab3BOPte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:49:34 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:33372 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948Ab3BOPtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:49:33 -0500
Date: Fri, 15 Feb 2013 16:49:31 +0100
From: Andreas Mohr <andi@lisas.de>
To: "Zhang, Rui" <rui.zhang@intel.com>
Cc: Andreas Mohr <andi@lisas.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "R, Durgadoss" <durgadoss.r@intel.com>,
        "peter@piie.net" <peter@piie.net>, "lenb@kernel.org" <lenb@kernel.org>
Subject: Re: thermal governor: does it actually work??
Message-ID: <20130215154931.GA26213@rhlx01.hs-esslingen.de>
References: <20130214153255.GA5033@rhlx01.hs-esslingen.de>
 <744357E9AAD1214791ACBA4B0B90926329ED72@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <744357E9AAD1214791ACBA4B0B90926329ED72@SHSMSX101.ccr.corp.intel.com>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Feb 15, 2013 at 09:47:07AM +0000, Zhang, Rui wrote:
> Please attach the output of
> "grep . /sys/class/thermal/thermal_zone*/cdev*/*"?

# grep . /sys/class/thermal/thermal_zone*/cdev*/*
/sys/class/thermal/thermal_zone0/cdev0/cur_state:1
/sys/class/thermal/thermal_zone0/cdev0/max_state:1
grep: /sys/class/thermal/thermal_zone0/cdev0/power: Is a directory
grep: /sys/class/thermal/thermal_zone0/cdev0/subsystem: Is a directory
/sys/class/thermal/thermal_zone0/cdev0/type:acerhdf-fan

> The question is that if we can also call it "throttle" when reducing the device performance to generate less heat.

I won't continue to elaborate on this separate issue now, given that my time
currently is very limited ;)

Andreas Mohr
