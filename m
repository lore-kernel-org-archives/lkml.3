Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936919Ab3DJRu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:50:28 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:57043 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933146Ab3DJRu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:50:27 -0400
Date: Wed, 10 Apr 2013 10:50:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Add additional distro specific
 Kconfig options
Message-ID: <20130410175025.GA4644@kroah.com>
References: <1365610097-10955-1-git-send-email-kys@microsoft.com>
 <20130410154957.GA13849@kroah.com>
 <a3b67bf6e11c462d826c1fc4957c3da9@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130410163340.GA21840@kroah.com>
 <a6d2f8d7a9bf48cda759bf7029192c4d@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6d2f8d7a9bf48cda759bf7029192c4d@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 05:37:41PM +0000, KY Srinivasan wrote:
> You are reading more into this than there is. As it stands now
> (without this patch), the code that constructs the guest OS ID has
> place holders for adding in some distro specific tags into this ID.

I understand that, the fact that you now want this to be a configurable
value at build time, yet provide exactly NO information to anyone as to
what to set the values to, what the values mean, or anything else about
these values this is why I am rejecting this patch.

If you are already properly handling os-release, then there is no need
for these values to mean anything for a Linux guest, as it would be
totally redundant, and probably wrong (hint, the same kernel binary can
be running on different os userspace layers.)

sorry,

greg k-h
