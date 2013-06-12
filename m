Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866Ab3FLDJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 23:09:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418Ab3FLDJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 23:09:05 -0400
Date: Tue, 11 Jun 2013 20:09:41 -0700
From: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>, linux-kernel@vger.kernel.org,
        thierry.reding@gmail.com, patches@linaro.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH 09/15] net: can: Convert to use devm_ioremap_resource
Message-ID: <20130612030941.GA10250@kroah.com>
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
 <1370864113-17895-10-git-send-email-tushar.behera@linaro.org>
 <51B5D007.8050005@pengutronix.de>
 <51B69663.5080304@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B69663.5080304@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 08:45:47AM +0530, Tushar Behera wrote:
> +CC: 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>
> 
> On 06/10/2013 06:39 PM, Marc Kleine-Budde wrote:
> > On 06/10/2013 01:35 PM, Tushar Behera wrote:
> >> Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
> >> introduced devm_ioremap_resource() and deprecated the use of
> >> devm_request_and_ioremap().
> > 
> > Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
> > 
> > Are the patches going over the individual subsystem maintainers?
> > 
> > Marc
> > 
> 
> I am not sure. Looping in Greg for clarity.

I'm taking the ones for my subsystem(s), the last one should probably go
in after 3.11-rc1 is released, in order to ensure no remaining in-tree
users of the function are still around.

thanks,

greg k-h
