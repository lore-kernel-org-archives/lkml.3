Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab3HLIxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 04:53:51 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:38607 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab3HLIxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 04:53:48 -0400
Message-ID: <1376297561.7709.35.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH v2 3/6] usb: phy: msm: Migrate to Managed Device
 Resource allocation
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 12 Aug 2013 11:52:41 +0300
In-Reply-To: <20130729122522.GI24801@radagast>
References: <1375081464-14206-1-git-send-email-iivanov@mm-sol.com>
	 <1375081464-14206-4-git-send-email-iivanov@mm-sol.com>
	 <20130729122522.GI24801@radagast>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

On Mon, 2013-07-29 at 15:25 +0300, Felipe Balbi wrote:
> Hi,
> 
> On Mon, Jul 29, 2013 at 10:04:21AM +0300, Ivan T. Ivanov wrote:
> >  	motg->irq = platform_get_irq(pdev, 0);
> > -	if (!motg->irq) {
> > +	if (motg->irq < 0) {
> 
> looks like this particular hunk isn't part of $subject.
> 

Indeed. Will remove it. 

Thanks, 
Ivan


