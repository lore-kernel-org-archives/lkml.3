Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934116AbaGXDxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 23:53:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758482AbaGXDxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 23:53:53 -0400
Date: Wed, 23 Jul 2014 20:53:28 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Dexuan Cui <decui@microsoft.com>
Cc: "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "tomi.valkeinen@ti.com" <tomi.valkeinen@ti.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH v3] video: hyperv: hyperv_fb: refresh the VM screen by
 force on VM panic
Message-ID: <20140724035328.GB7484@kroah.com>
References: <1404875063-27424-1-git-send-email-decui@microsoft.com>
 <EE124450C0AAF944A40DD71E61F878C98D83A8@SINEX14MBXC417.southpacific.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EE124450C0AAF944A40DD71E61F878C98D83A8@SINEX14MBXC417.southpacific.corp.microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 01:54:58AM +0000, Dexuan Cui wrote:
> Ping again -- any one has further comment for the v3 version?
> 
> It looks the framebuffer layer's Tomi and Jean-Christophe are out recently?
> Recently I don't see mail from them since Jul 1 and Jul 8 in the lists.
> 
> Though the patch belongs to driver/video/fbdev/, it only changes hyper-v stuff
> and only changes one file and the patch itself is straightforward IMO.
> 
> So, hi Greg and all, 
> If you think the patch itself is OK, may I know if it's OK for the patch to go
> into Greg's char-misc.git tree, as some other hyper-v patches did?

No, it needs to go through the fb tree, not mine, sorry.

greg k-h
