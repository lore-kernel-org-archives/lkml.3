Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbaA1Qm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 11:42:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:11505 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685AbaA1Qmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 11:42:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,736,1384329600"; 
   d="scan'208";a="466028006"
Date: Tue, 28 Jan 2014 08:48:00 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
To: "xinhui.pan" <xinhuix.pan@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linus.walleij@linaro.org, gnurou@gmail.com,
        yanmin_zhang@linux.intel.com
Subject: Re: [PATCH] gpio-intel-mid: fix the incorrect return of idle callback
Message-ID: <20140128164800.GA28816@psi-dev26.jf.intel.com>
References: <52E76F71.4080304@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E76F71.4080304@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the patch :)

On Tue, Jan 28, 2014 at 04:50:57PM +0800, xinhui.pan wrote:
> From: "xinhui.pan" <xinhuiX.pan@intel.com>
> 
> intel_gpio_runtime_idle should return correct error code if it do fail.
> make it more correct even though -EBUSY is the most possible return value.
> 
> Signed-off-by: bo.he <bo.he@intel.com>
> Signed-off-by: xinhui.pan <xinhuiX.pan@intel.com>

Acked-by: David Cohen <david.a.cohen@linux.intel.com>
