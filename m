Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab3HBDKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 23:10:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab3HBDKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 23:10:47 -0400
Date: Fri, 2 Aug 2013 11:12:03 +0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Olaf Hering <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Tools: hv: in kvp_set_ip_info free mac_addr right after
 usage
Message-ID: <20130802031203.GC2329@kroah.com>
References: <1375361890-15339-1-git-send-email-olaf@aepfle.de>
 <847c519c55cc4479a6f47e7dc43a8a90@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <847c519c55cc4479a6f47e7dc43a8a90@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 02:35:36PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Olaf Hering [mailto:olaf@aepfle.de]
> > Sent: Thursday, August 01, 2013 8:58 AM
> > To: KY Srinivasan; gregkh@linuxfoundation.org
> > Cc: linux-kernel@vger.kernel.org; Olaf Hering
> > Subject: [PATCH] Tools: hv: in kvp_set_ip_info free mac_addr right after usage
> > 
> > ... to simplify error path in upcoming changes.
> > 
> > Signed-off-by: Olaf Hering <olaf@aepfle.de>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Can you resend this as well?

thanks,

greg k-h
