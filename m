Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab3HBDKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 23:10:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60532 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab3HBDKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 23:10:37 -0400
Date: Fri, 2 Aug 2013 11:11:53 +0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Olaf Hering <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Tools: hv: check return value of system in hv_kvp_daemon
Message-ID: <20130802031153.GB2329@kroah.com>
References: <1375362236-15661-1-git-send-email-olaf@aepfle.de>
 <025723e33c064320904b285318896ade@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <025723e33c064320904b285318896ade@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 02:36:10PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Olaf Hering [mailto:olaf@aepfle.de]
> > Sent: Thursday, August 01, 2013 9:04 AM
> > To: KY Srinivasan; gregkh@linuxfoundation.org
> > Cc: linux-kernel@vger.kernel.org; Olaf Hering
> > Subject: [PATCH] Tools: hv: check return value of system in hv_kvp_daemon
> > 
> > hv_kvp_daemon.c: In function 'main':
> > hv_kvp_daemon.c:1441:8: warning: ignoring return value of 'daemon', declared
> > with attribute warn_unused_result [-Wunused-result]
> > 
> > Signed-off-by: Olaf Hering <olaf@aepfle.de>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Can you please resend this to me, I don't seem to have a copy of it
anywhere.

thanks,

greg k-h
