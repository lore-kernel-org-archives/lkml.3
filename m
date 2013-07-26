Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736Ab3GZMc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 08:32:29 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:52942 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757916Ab3GZMc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:32:27 -0400
Message-ID: <1374841894.1956.42.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH v2 3/7] usb: phy: msm: Move regulator usage to managed
 resource allocation
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Fri, 26 Jul 2013 15:31:34 +0300
In-Reply-To: <1374759788.1956.31.camel@iivanov-dev.int.mm-sol.com>
References: <1373384833-18077-1-git-send-email-iivanov@mm-sol.com>
	 <1373384833-18077-4-git-send-email-iivanov@mm-sol.com>
	 <20130724123912.GI17962@radagast>
	 <1374759788.1956.31.camel@iivanov-dev.int.mm-sol.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Felipe, 

On Thu, 2013-07-25 at 16:43 +0300, Ivan T. Ivanov wrote:
> On Wed, 2013-07-24 at 15:39 +0300, Felipe Balbi wrote:
> > On Tue, Jul 09, 2013 at 06:47:09PM +0300, Ivan T. Ivanov wrote:
> > > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > > 
> > > This patch move global regulators variables to driver state
> > > structire and move allocation of the regulators to be devm managed.
> > 
> > split into two patches please. One for moving the global regulators into
> > your structure and a separate patch to move to devm_*
> > 

Would you accept patch which convert all resources allocation to devm_
variants in single patch or you prefer separate patches for memory, 
clocks, regulators and irq?

Regards,
Ivan

> 
> Ok, will do and resend.
> 
> Ivan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


