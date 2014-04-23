Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284AbaDWUE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 16:04:28 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:40830 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbaDWUEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 16:04:25 -0400
Date: Wed, 23 Apr 2014 23:00:04 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, m.szyprowski@samsung.com,
        t.figa@samsung.com
Subject: Re: [PATCH v2 00/13] extcon: major rework
Message-ID: <20140423200004.GA575@drone.musicnaut.iki.fi>
References: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Apr 14, 2014 at 01:46:11PM +0200, Robert Baldyga wrote:
> This patchset adds many improvements to extcon class driver and extcon
> provider drivers. It changes extcon API to faster and safer by replaceing
> function taking extcon and cable names with functions working with
> structures representing this objects.

Given the first patch series broke even compilation on OMAP1, I think
you should provide some test results with the next resend.
You should at least compile-test the drivers you modify, or even better,
ask people to test your changes if you don't have the HW available.

Thanks,

A.
