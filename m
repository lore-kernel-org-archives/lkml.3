Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaCGJVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:21:12 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40752 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaCGJVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:21:07 -0500
Date: Fri, 7 Mar 2014 12:20:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Include the limit on the number
 of pfns we can handle
Message-ID: <20140307092038.GG4774@mwanda>
References: <1394176508-1439-1-git-send-email-kys@microsoft.com>
 <20140307081627.GC29018@mwanda>
 <9037d4ef9c174fb280f00f22912c3d12@BY2PR03MB299.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9037d4ef9c174fb280f00f22912c3d12@BY2PR03MB299.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 09:07:42AM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> > Sent: Friday, March 7, 2014 1:46 PM
> > To: KY Srinivasan
> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > jasowang@redhat.com
> > Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Include the limit on the number
> > of pfns we can handle
> > 
> > On Thu, Mar 06, 2014 at 11:15:08PM -0800, K. Y. Srinivasan wrote:
> > > Increase the maximum number of pfns we can handle is a single vmbus
> > packet.
> >                                                     ^^ in
> 
> Thanks Dan. I am traveling in India and it shows. I have already sent a corrected patch.
> 

Yeah.  I saw that.  Thanks.

> > >
> > 
> > What are the user visible effects of this patch?
> The current code will drop these packets that have more PFNs than the limit.
> Upping the limit will mitigate this problem.
> 

Meanwhile, the revised patch says that it is not a bugfix.  It sort of
sounds like upping the limit does improve performance for some people?

I am confused now.

regards,
dan carpenter

