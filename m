Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab3ALAOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 19:14:41 -0500
Received: from mail.kernel.org ([198.145.19.201]:39080 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843Ab3ALAOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 19:14:40 -0500
Date: Fri, 11 Jan 2013 16:14:33 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 2/2] usb: host: tegra: Resetting PORT0 based on
 information received via DT.
Message-ID: <20130112001433.GB21909@kroah.com>
References: <1357198179-10031-1-git-send-email-vbyravarasu@nvidia.com>
 <1357198179-10031-3-git-send-email-vbyravarasu@nvidia.com>
 <50E5EA2C.609@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50E5EA2C.609@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 01:29:32PM -0700, Stephen Warren wrote:
> On 01/03/2013 12:29 AM, Venu Byravarasu wrote:
> > Tegra USB host driver is using port instance number,
> > to handle some of the hardware issues on SOC e.g. reset PORT0
> > twice etc. As instance number based handling looks ugly,
> > making use of information passed through DT for achieving this.
> > 
> > Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> > Acked-by: Alan Stern <stern@rowland.harvard.edu>
> 
> Greg, recall that I'm hoping to take this series through the Tegra tree
> in order to manage EHCI/PHY/clock dependencies. I'm hoping to get your
> ack if required, or is Alan's sufficient for this? Thanks.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
