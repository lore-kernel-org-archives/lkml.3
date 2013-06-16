Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab3FPWAU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:00:20 -0400
Received: from ballcam.com ([184.173.145.60]:56196 "HELO ballcam.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754207Ab3FPWAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:00:19 -0400
Date: Sun, 16 Jun 2013 17:00:18 -0500
From: kernel-dev@ballcam.com
To: linux-kernel@vger.kernel.org
Subject: Re: [QUESTION] LVDS / MIPI
Message-ID: <20130616220018.GA21696@ballcam.com>
References: <20130616151901.GA18705@fireacop.com>
 <Pine.LNX.4.64.1306162240010.20284@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1306162240010.20284@axis700.grange>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 16, 2013 at 10:45:38PM +0200, Guennadi Liakhovetski wrote:
> On Sun, 16 Jun 2013, kernel-dev@fireacop.com wrote:
> 
> > I have checked the Kernel Source and the Internet.
> > 
> > Not much if any support for LVDS / MIPI.
> 
> What exactly do you need support for? MIPI CSI (2/3) capture?
> 
> Thanks
> Guennadi

To be most specific, I am looking for support for 
the LVDS/MIPI interface on the Gumstix Duovero.

They have a 2-lane, and a 5-lane LVDS interface.

To the best of my knowledge at this point, 
they are GPIO lines dedicated to that purpose.

Thanks.



