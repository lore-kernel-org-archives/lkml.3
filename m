Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053AbaECGpX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 02:45:23 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:44386 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaECGpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 02:45:22 -0400
Message-ID: <1399099520.7131.1.camel@violet>
Subject: Re: [PATCH v8 17/20] usb: phy: msm: Select secondary PHY via TCSR
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Tim Bird <tbird20d@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Tim Bird <tim.bird@sonymobile.com>
Date: Sat, 03 May 2014 09:45:20 +0300
In-Reply-To: <1398692063-11372-18-git-send-email-iivanov@mm-sol.com>
References: <1398692063-11372-1-git-send-email-iivanov@mm-sol.com>
	 <1398692063-11372-18-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 16:34 +0300, Ivan T. Ivanov wrote:
> From: Tim Bird <tbird20d@gmail.com>
> 
> Select the secondary PHY using the TCSR register, if phy-num=1
> in the DTS (or phy_number is set in the platform data).  The
> SOC has 2 PHYs which can be used with the OTG port, and this
> code allows configuring the correct one.
> 
> Note: This resolves the problem I was seeing where I couldn't
> get the USB driver working at all on a dragonboard, from cold
> boot.  This patch depends on patch 5/14 from Ivan's msm USB
> patch set.  It does not use DT for the register address, as
> there's no evidence that this address changes between SoC
> versions.
> 
> Signed-off-by: Tim Bird <tim.bird@sonymobile.com>

Missed this:

Signed-of-by: Ivan T. Ivanov <iivanov@mm-sol.com>

Regards,
Ivan

