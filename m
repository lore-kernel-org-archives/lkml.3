Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab3JGH62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 03:58:28 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:50873 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937Ab3JGH6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 03:58:25 -0400
Message-ID: <1381132624.24031.45.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH v5 1/3] usb: dwc3: msm: Add device tree binding
 information
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        gregkh@linuxfoundation.org, grant.likely@linaro.org,
        idos@codeaurora.org, mgautam@codeaurora.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Mon, 07 Oct 2013 10:57:04 +0300
In-Reply-To: <20131004143151.GD16059@radagast>
References: <1377091786-5613-1-git-send-email-iivanov@mm-sol.com>
	 <1377091786-5613-2-git-send-email-iivanov@mm-sol.com>
	 <20131004143151.GD16059@radagast>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Felipe,

On Fri, 2013-10-04 at 09:31 -0500, Felipe Balbi wrote: 
> On Wed, Aug 21, 2013 at 04:29:44PM +0300, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > MSM USB3.0 core wrapper consist of USB3.0 IP from Synopsys
> > (SNPS) and HS, SS PHY's control and configuration registers.
> > 
> > It could operate in device mode (SS, HS, FS) and host
> > mode (SS, HS, FS, LS).
> > 
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> 
> these patches were sent *ages* and nobody from DT mailing list has
> reviewed. Unless someone steps up now, I'll be queueing these patches
> next week.
> 

Please take v6 of the patch set, which I have just posted. 
They contain several fixes and I have also added ACK from
Stephen Warren for DT part.

Thanks, 
Ivan

