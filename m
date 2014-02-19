Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbaBSPuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 10:50:05 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:56042 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565AbaBSPuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:50:01 -0500
Message-ID: <1392824921.17130.71.camel@iivanov-dev>
Subject: Re: [PATCH v2 2/3] usb: chipidea: msm: Add device tree support
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Peter Chen <Peter.Chen@freescale.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Wed, 19 Feb 2014 17:48:41 +0200
In-Reply-To: <5303A71B.7060208@cogentembedded.com>
References: <1392729681-21022-1-git-send-email-iivanov@mm-sol.com>
		 <1392729681-21022-3-git-send-email-iivanov@mm-sol.com>
		 <53039E2E.2030503@cogentembedded.com>
	 <1392743648.17130.17.camel@iivanov-dev>
	 <5303A71B.7060208@cogentembedded.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tue, 2014-02-18 at 21:31 +0300, Sergei Shtylyov wrote: 
> On 02/18/2014 08:14 PM, Ivan T. Ivanov wrote:
> 
> >>> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> >>> Allows controller to be specified via device tree.
> >>> Pass PHY phandle specified in DT to core driver.
> 
> >>> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> >>> ---
> >>>    drivers/usb/chipidea/ci_hdrc_msm.c |   23 ++++++++++++++++++++++-
> >>>    1 file changed, 22 insertions(+), 1 deletion(-)
> 
> >>      You also need to describe the binding you're creating in
> >> Documentation/devicetree/bindings/usb/<file>.txt.
> 
> > Did you check "[PATCH v2 1/3]"?
> 
>     Did you send it to 'linux-usb'?

Opps, sorry. get_maintainer.pl did not list linux-usb and I forgot 
to add it. Would like to resend it?

Regards,
Ivan

> 
> WBR, Sergei


