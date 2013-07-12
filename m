Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab3GLVNG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 17:13:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55425 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757541Ab3GLVND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 17:13:03 -0400
Date: Fri, 12 Jul 2013 22:12:56 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Stable <stable@vger.kernel.org>
Message-ID: <20130712211256.GC7729@decadent.org.uk>
References: <1373637292-25855-1-git-send-email-kys@microsoft.com>
 <1373637375-25936-1-git-send-email-kys@microsoft.com>
 <20130712201703.GB7729@decadent.org.uk>
 <a53af503f3934a6bb8442e97de0d5ddc@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a53af503f3934a6bb8442e97de0d5ddc@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH 1/2] Drivers: hv: balloon: Fix a bug in the hot-add code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 09:07:19PM +0000, KY Srinivasan wrote:
[...]
> > Well now it might look like a bug that you don't test the result
> > of wait_for_completion_timeout().  Maybe update the comment to
> > explain why it's OK to continue anyway?
> 
> I put in the comment in the patch explaining why it is ok to continue.
[...]

But that is not nearly as easy to see as the comment that is
already *in the code* which your patch isn't updating.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
