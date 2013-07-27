Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab3G0Gyq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 02:54:46 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:45374 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543Ab3G0Gyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 02:54:44 -0400
Subject: Re: [PATCH v2 3/7] usb: phy: msm: Move regulator usage to managed
 resource allocation
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
In-Reply-To: <20130726202820.GA14077@radagast>
References: <1373384833-18077-1-git-send-email-iivanov@mm-sol.com>
	 <1373384833-18077-4-git-send-email-iivanov@mm-sol.com>
	 <20130724123912.GI17962@radagast>
	 <1374759788.1956.31.camel@iivanov-dev.int.mm-sol.com>
	 <1374841894.1956.42.camel@iivanov-dev.int.mm-sol.com>
	 <20130726202820.GA14077@radagast>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Jul 2013 09:54:41 +0300
Message-ID: <1374908081.29094.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-26 at 23:28 +0300, Felipe Balbi wrote:
> On Fri, Jul 26, 2013 at 03:31:34PM +0300, Ivan T. Ivanov wrote:
> > 
> > Hi Felipe, 
> > 
> > On Thu, 2013-07-25 at 16:43 +0300, Ivan T. Ivanov wrote:
> > > On Wed, 2013-07-24 at 15:39 +0300, Felipe Balbi wrote:
> > > > On Tue, Jul 09, 2013 at 06:47:09PM +0300, Ivan T. Ivanov wrote:
> > > > > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > > > > 
> > > > > This patch move global regulators variables to driver state
> > > > > structire and move allocation of the regulators to be devm managed.
> > > > 
> > > > split into two patches please. One for moving the global regulators into
> > > > your structure and a separate patch to move to devm_*
> > > > 
> > 
> > Would you accept patch which convert all resources allocation to devm_
> > variants in single patch or you prefer separate patches for memory, 
> > clocks, regulators and irq?
> 
> devm_* all over the place should be fine ;-)
> 

Thanks, it is coming. 

Regards,
Ivan

