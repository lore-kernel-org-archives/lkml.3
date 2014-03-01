Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbaCAPdo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 10:33:44 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:53702 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbaCAPdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 10:33:43 -0500
Message-ID: <5311FDD1.3050306@linaro.org>
Date: Sat, 01 Mar 2014 23:33:37 +0800
From: Julien Grall <julien.grall@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Ian Campbell <Ian.Campbell@citrix.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, xen-devel@lists.xenproject.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/2] arm/xen: Don't use xen DMA ops when the device is
 protected by an IOMMU
References: <1392913301-25524-1-git-send-email-julien.grall@linaro.org> <1392914159.32657.18.camel@kazak.uk.xensource.com> <alpine.DEB.2.02.1402241214570.4471@kaball.uk.xensource.com> <20140224151636.GA13489@kroah.com> <alpine.DEB.2.02.1402242036490.31489@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1402242036490.31489@kaball.uk.xensource.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefano,

On 25/02/14 04:49, Stefano Stabellini wrote:
> Julien, could you please come up with a simple patch to demonstrate the
> concept?
>

Sure. I won't have time to write the patch next week. I will try to send 
it as soon as possible.

Cheers,

-- 
Julien Grall
