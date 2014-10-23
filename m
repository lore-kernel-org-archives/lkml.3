Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbaJWRKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 13:10:30 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:57187 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721AbaJWRK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 13:10:27 -0400
Message-ID: <1414084222.17121.30.camel@x220>
Subject: Re: [PATCHv5 7/7] usb: dwc2: Update Kconfig to support dual-role
From: Paul Bolle <pebolle@tiscali.nl>
To: Dinh Nguyen <dinguyen@opensource.altera.com>
Cc: paulz@synopsys.com, balbi@ti.com, dinh.linux@gmail.com,
        linux-kernel@vger.kernel.org, swarren@wwwdotorg.org,
        b.zolnierkie@samsung.com, matthijs@stdin.nl, r.baldyga@samsung.com,
        jg1.han@samsung.com, sachin.kamat@linaro.org, ben-linux@fluff.org,
        dianders@chromium.org, kever.yang@rock-chips.com,
        linux-usb@vger.kernel.org
Date: Thu, 23 Oct 2014 19:10:22 +0200
In-Reply-To: <54491947.4010008@opensource.altera.com>
References: <1413831126-24193-1-git-send-email-dinguyen@opensource.altera.com>
			 <1413831126-24193-8-git-send-email-dinguyen@opensource.altera.com>
		 <1413834151.2010.19.camel@x41> <5446C668.3020609@opensource.altera.com>
	 <1414009627.17121.15.camel@x220> <54491947.4010008@opensource.altera.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Oct 2014 17:10:22.0821 (UTC) FILETIME=[3B14D950:01CFEEE4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-23 at 10:05 -0500, Dinh Nguyen wrote:
> On 10/22/2014 03:27 PM, Paul Bolle wrote:
> > On Tue, 2014-10-21 at 15:47 -0500, Dinh Nguyen wrote:
> Well, CONFIG_USB enables the host stack that is needed by the DWC2
> driver, without CONFIG_USB, the DWC2 driver will not be able to build.
>
> >> In addition, thanks to your comment, I realized that DWC2 should also be
> >> available to build when USB_GADGET is enabled. A patch has been sent:
> >>
> >> http://marc.info/?l=linux-usb&m=141392377124818&w=2

Doesn't that patch contradict your statement? It allows USB_DWC2 to be
set even if USB is not set.

> > I haven't checked, but doesn't this mean USB_DWC2 could just depend on
> > USB_SUPPORT?
> > 
> I don't think so because USB_SUPPORT will not select USB or USB_GAGDGET,
> and the DWC2 driver will need either 1 or both for it to build correctly.

My comment was not well thought through. It was a waste of your time.


Paul Bolle

