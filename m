Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002Ab3CLQGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 12:06:44 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:54119 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932924Ab3CLQGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 12:06:42 -0400
Date: Tue, 12 Mar 2013 09:07:22 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [PATCH 5/6] Drivers: hv: balloon: Implement hot-add functionality
Message-ID: <20130312160722.GA21109@kroah.com>
References: <1362780945-9796-1-git-send-email-kys@microsoft.com>
 <1362780973-9837-1-git-send-email-kys@microsoft.com>
 <1362780973-9837-5-git-send-email-kys@microsoft.com>
 <924741bf41f14975af2f8f52b3251730@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924741bf41f14975af2f8f52b3251730@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 02:54:23AM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> > Sent: Friday, March 08, 2013 5:16 PM
> > To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > jasowang@redhat.com
> > Cc: KY Srinivasan
> > Subject: [PATCH 5/6] Drivers: hv: balloon: Implement hot-add functionality
> > 
> > Implement the memory hot-add functionality. With this, Linux guests can fully
> > participate in the Dynamic Memory protocol implemented in the Windows hosts.
> 
> Greg,
> 
> I forgot to modify the Kconfig file to include the new dependency of the balloon driver on
> MEMORY_HOTPLUG. Should I send a separate patch for  Kconfig, or resend this one patch
> with the Kconfig changes folded in. Or, do you want me to resend the whole series.

Just resend the whole series, I'll drop this one.

greg k-h
