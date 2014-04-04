Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaDDMPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 08:15:19 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:4703 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294AbaDDMPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 08:15:15 -0400
X-IronPort-AV: E=Sophos;i="4.97,795,1389744000"; 
   d="scan'208";a="116776933"
Message-ID: <533EA250.90709@citrix.com>
Date: Fri, 4 Apr 2014 13:15:12 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Julien Grall <julien.grall@linaro.org>
CC: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>, <linux-kernel@vger.kernel.org>,
        Xen <xen-devel@lists.xenproject.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ian Campbell <ian.campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH] Xen: do hv callback accounting only on x86
References: <5057041.71iuvlcH4G@wuerfel> <12121341.4lKFpaRMcO@wuerfel> <533E9A75.4050102@linaro.org>
In-Reply-To: <533E9A75.4050102@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/14 12:41, Julien Grall wrote:
> 
> Linus has merged xen/tip yesterday and building ARM with CONFIG_XEN=y is
> now broken.

Sorry, I couldn't add this patch to the xen tree at the time since the
change was on a different tree and then I forgot about it.

Now applied to devel/for-linus-3.15.

David
