Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbaJNNKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 09:10:55 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:36225 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbaJNNKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 09:10:54 -0400
Date: Tue, 14 Oct 2014 16:10:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thomas Shao <huishao@microsoft.com>
Cc: "olaf@aepfle.de" <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] hyperv: Implement Time Synchronization using host
 time sample
Message-ID: <20141014131024.GX23154@mwanda>
References: <1413285078-7027-1-git-send-email-huishao@microsoft.com>
 <20141014111915.GV23154@mwanda>
 <CD2CABCB2C0A0D4682C5F8AD840141540BFD19@HKXPRD3002MB006.064d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CD2CABCB2C0A0D4682C5F8AD840141540BFD19@HKXPRD3002MB006.064d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 12:50:23PM +0000, Thomas Shao wrote:
> > > -static inline void do_adj_guesttime(u64 hosttime)
> > > +static inline void do_adj_guesttime(u64 hosttime, bool forceSync)
> > 
> > I'm surprise checkpatch.pl does't complain about this CamelCase.
> 
> I've run the scripts/checkpatch.pl, it didn't complain anything. I'll change to forcesync.

->force_sync is normal kernel style.

regards,
dan carpenter

