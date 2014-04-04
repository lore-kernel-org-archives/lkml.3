Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaDDLuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 07:50:52 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:58636 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbaDDLuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 07:50:51 -0400
Message-ID: <533E9C94.5040902@linaro.org>
Date: Fri, 04 Apr 2014 12:50:44 +0100
From: Julien Grall <julien.grall@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Xen <xen-devel@lists.xenproject.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ian Campbell <ian.campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH] Xen: do hv callback accounting only on x86
References: <5057041.71iuvlcH4G@wuerfel> <12121341.4lKFpaRMcO@wuerfel> <533E9A75.4050102@linaro.org>
In-Reply-To: <533E9A75.4050102@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2014 12:41 PM, Julien Grall wrote:
> Linus has merged xen/tip yesterday and building ARM with CONFIG_XEN=y is
> now broken.

My mistake, it's not because of xen/tip, but some other branches.

-- 
Julien Grall
