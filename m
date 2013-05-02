Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760783Ab3EBRrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:47:24 -0400
Received: from vaxjo.synopsys.com ([198.182.60.75]:61005 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab3EBRrW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:47:22 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Matthijs Kooijman <matthijs@stdin.nl>,
        Laurent Navet <laurent.navet@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging: dwc2: use devm_ioremap_resource()
Thread-Topic: [PATCH] staging: dwc2: use devm_ioremap_resource()
Thread-Index: AQHORyZXSnh6WfrcfEelqUq0aE8L8pjyNbWA///1DDA=
Date: Thu, 2 May 2013 17:47:21 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030458DB09A6@US01WEMBX2.internal.synopsys.com>
References: <1367493798-32354-1-git-send-email-laurent.navet@gmail.com>
 <20130502112228.GI13691@login.drsnuggles.stderr.nl>
In-Reply-To: <20130502112228.GI13691@login.drsnuggles.stderr.nl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Matthijs Kooijman [mailto:matthijs@stdin.nl]
> Sent: Thursday, May 02, 2013 4:22 AM
> 
> On Thu, May 02, 2013 at 01:23:17PM +0200, Laurent Navet wrote:
> > Replace a call to deprecated devm_request_and_ioremap by devm_ioremap_resource.
> >
> > Found with coccicheck and this semantic patch:
> >  scripts/coccinelle/api/devm_request_and_ioremap.cocci.
> >
> > Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
> > ---
> >  drivers/staging/dwc2/pci.c |    6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> Patch looks good, I had a bit-for-bit identical patch in my queue here
> as well :-)
> 
> Reviewed-by: Matthijs Kooijman <matthijs@stdin.nl>

Acked-by: Paul Zimmerman <paulz@synopsys.com>

