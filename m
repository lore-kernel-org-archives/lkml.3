Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbaDXOcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:32:32 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:46028 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757859AbaDXOc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:32:27 -0400
Message-ID: <1398349891.4724.233.camel@iivanov-dev>
Subject: Re: [PATCH v4 0/3] usb: chipidea: msm: Clean and fix glue layer
 driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Peter Chen <peter.chen@freescale.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Thu, 24 Apr 2014 17:31:31 +0300
In-Reply-To: <20140424003854.GA25407@shlinux1.ap.freescale.net>
References: <1398256084-6815-1-git-send-email-iivanov@mm-sol.com>
	 <20140424003854.GA25407@shlinux1.ap.freescale.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Peter, 

On Thu, 2014-04-24 at 08:38 +0800, Peter Chen wrote:
> On Wed, Apr 23, 2014 at 03:28:01PM +0300, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > This series intend to fix driver, which was broken for a while.
> > It is used to create peripheral role device, which in coordination
> > with phy-usb-msm driver could provide USB2.0 gadget support for
> > Qualcomm targets.
> > 
> > Changes since version 3.
> > 
> >  - Fix typo in devicetree description file.
> > 
> > Previews version can be found here:
> 
> Since in your phy's patchset, you also access portsc which is in
> chipidea register region, it is not a standard way.
> In case, you will change something at chipidea driver in future
> when you re-work your next revision phy's patchset, I do not
> send this patchset to Greg right now.
> 

Did you see problems with _this_ particular patch set? There is no
direct dependency between PHY patches and these changes. 

Regards,
Ivan

> Once your phy's patchset has accepted, notify me. I will send
> this patchset to Greg.
> 
> Peter
> 
> > 
> > https://lkml.org/lkml/2014/4/22/195
> > 
> > Ivan T. Ivanov (3):
> >   usb: chipidea: msm: Add device tree binding information
> >   usb: chipidea: msm: Add device tree support
> >   usb: chipidea: msm: Initialize offset of the capability registers
> > 
> >  .../devicetree/bindings/usb/ci-hdrc-qcom.txt       | 17 +++++++++++++++
> >  drivers/usb/chipidea/ci_hdrc_msm.c                 | 24 +++++++++++++++++++++-
> >  2 files changed, 40 insertions(+), 1 deletion(-)
> >  create mode 100644 Documentation/devicetree/bindings/usb/ci-hdrc-qcom.txt
> > 
> > --
> > 1.8.3.2
> > 
> > 
> > 
> 


