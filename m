Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188AbaDVPU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:20:58 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:54157 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932331AbaDVPUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:20:54 -0400
Message-ID: <1398179997.4724.172.camel@iivanov-dev>
Subject: Re: [PATCH v6 04/19] usb: phy: msm: Migrate to Managed Device
 Resource allocation
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Tue, 22 Apr 2014 18:19:57 +0300
In-Reply-To: <535685C0.5070800@linaro.org>
References: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
	 <1398158438-21579-5-git-send-email-iivanov@mm-sol.com>
	 <535685C0.5070800@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-22 at 16:07 +0100, Srinivas Kandagatla wrote:
> 
> On 22/04/14 10:20, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> >
> > Move memory, regulators, clocks and irq allocation to
> > devm_* variants. Properly check for valid clk handles.
> >
> >
> > -module_platform_driver_probe(msm_otg_driver, msm_otg_probe);
> > +module_platform_driver(msm_otg_driver);
> 
> This change doesn’t match the log.

Right, I have erroneously assumed that devm_ functions are those 
which returns EPROBE_DEFER.

Will make it separate change.

Thanks,
Ivan

