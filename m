Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab3CDKoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 05:44:54 -0500
Received: from mga03.intel.com ([143.182.124.21]:55166 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756612Ab3CDKox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 05:44:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,778,1355126400"; 
   d="scan'208";a="208511400"
Date: Mon, 4 Mar 2013 11:44:49 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Ian Lartey <ian@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, ldewangan@nvidia.com,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH] mfd: palmas: is_palmas_charger needed by multiple drivers
Message-ID: <20130304104449.GB25973@sortiz-mobl>
References: <1361890048-24555-1-git-send-email-ian@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361890048-24555-1-git-send-email-ian@slimlogic.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian,

On Tue, Feb 26, 2013 at 02:47:28PM +0000, Ian Lartey wrote:
> is_palmas_charger checks for the presence of charging
> functionality in the device
> 
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
> Acked-by: Laxman Dewangan<ldewangan@nvidia.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
