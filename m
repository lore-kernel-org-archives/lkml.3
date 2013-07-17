Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab3GQROD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:14:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49318 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab3GQROB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:14:01 -0400
Date: Wed, 17 Jul 2013 10:12:52 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [PATCH 1/1] Drivers: hv: util: Fix a bug in version negotiation
 code for util services
Message-ID: <20130717171252.GA15698@kroah.com>
References: <1372786290-12641-1-git-send-email-kys@microsoft.com>
 <39fe1ebc4d4d45488f30612bd942f3e1@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39fe1ebc4d4d45488f30612bd942f3e1@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 12:35:42PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> > Sent: Tuesday, July 02, 2013 1:32 PM
> > To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > jasowang@redhat.com
> > Cc: KY Srinivasan
> > Subject: [PATCH 1/1] Drivers: hv: util: Fix a bug in version negotiation code for util
> > services
> > 
> > The current code picked the highest version advertised by the host. WS2012 R2
> > has implemented a protocol version for KVP that is not compatible with prior
> > protocol versions of KVP. Fix the bug in the current code by explicitly specifying
> > the protocol version that the guest can support.
> 
> Greg,
> 
> Do you want me to resubmit this patch.

No, it's not lost, I'm just working on 3.11 patches at the moment, I'll
push this one to 3.12 later.

thanks,

greg k-h
