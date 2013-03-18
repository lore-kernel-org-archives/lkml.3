Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab3CRQ3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:29:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52915 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab3CRQ3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:29:08 -0400
Date: Mon, 18 Mar 2013 17:29:06 +0100
From: Michal Hocko <mhocko@suse.cz>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kamezawa.hiroyuki@gmail.com" <kamezawa.hiroyuki@gmail.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "yinghan@google.com" <yinghan@google.com>
Subject: Re: [PATCH 2/2] Drivers: hv: balloon: Support 2M page allocations
 for ballooning
Message-ID: <20130318162906.GV10192@dhcp22.suse.cz>
References: <1363470088-24565-1-git-send-email-kys@microsoft.com>
 <1363470125-24606-1-git-send-email-kys@microsoft.com>
 <1363470125-24606-2-git-send-email-kys@microsoft.com>
 <20130318105257.GG10192@dhcp22.suse.cz>
 <1701384b10204014b53acecb006521b0@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130318141302.GO10192@dhcp22.suse.cz>
 <98cd176931934b59a0fcb1ec3448d86c@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98cd176931934b59a0fcb1ec3448d86c@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 18-03-13 15:08:36, KY Srinivasan wrote:
> What is your recommendation with regards which tree the mm patch needs
> to go through; the Hyper-V balloon driver patch will go through Greg's
> tree.

I would say via Andrew but there are dependencies between those two so a
single tree would be less confusing /me thinks.
-- 
Michal Hocko
SUSE Labs
