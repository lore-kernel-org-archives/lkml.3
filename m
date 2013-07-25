Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab3GYH5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 03:57:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33904 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782Ab3GYH5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 03:57:12 -0400
Date: Thu, 25 Jul 2013 09:57:05 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Dave Hansen <dave.hansen@intel.com>
Cc: KY Srinivasan <kys@microsoft.com>, Dave Hansen <dave@sr71.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kamezawa.hiroyuki@gmail.com" <kamezawa.hiroyuki@gmail.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "yinghan@google.com" <yinghan@google.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kay@vrfy.org" <kay@vrfy.org>
Subject: Re: [PATCH 1/1] Drivers: base: memory: Export symbols for onlining
 memory blocks
Message-ID: <20130725075705.GD12818@dhcp22.suse.cz>
References: <1374261785-1615-1-git-send-email-kys@microsoft.com>
 <20130722123716.GB24400@dhcp22.suse.cz>
 <e06fced3ca42408b980f8aa68f4a29f3@SN2PR03MB061.namprd03.prod.outlook.com>
 <51EEA11D.4030007@intel.com>
 <3318be0a96cb4d05838d76dc9d088cc0@SN2PR03MB061.namprd03.prod.outlook.com>
 <51EEA89F.9070309@intel.com>
 <9f351a549e76483d9148f87535567ea0@SN2PR03MB061.namprd03.prod.outlook.com>
 <51F00415.8070104@sr71.net>
 <d1f80c05986b439cbeef12bcd595b264@BLUPR03MB050.namprd03.prod.outlook.com>
 <51F040E8.1030507@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F040E8.1030507@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 24-07-13 14:02:32, Dave Hansen wrote:
> On 07/24/2013 12:45 PM, KY Srinivasan wrote:
> > All I am saying is that I see two classes of failures: (a) Our
> > inability to allocate memory to manage the memory that is being hot added
> > and (b) Our inability to bring the hot added memory online within a reasonable
> > amount of time. I am not sure the cause for (b) and I was just speculating that
> > this could be memory related. What is interesting is that I have seen failure related
> > to our inability to online the memory after having succeeded in hot adding the
> > memory.
> 
> I think we should hold off on this patch and other like it until we've
> been sufficiently able to explain how (b) happens.

Agreed.

-- 
Michal Hocko
SUSE Labs
