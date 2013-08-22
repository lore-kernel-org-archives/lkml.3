Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab3HVQEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:04:51 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:46930 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab3HVQEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:04:49 -0400
Message-ID: <1377187485.1703.43.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: Null pointer dereference in nl80211_set_reg
From: Ben Hutchings <bhutchings@solarflare.com>
To: <udo@hypervisor.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Linux Network Mailing List" <netdev@vger.kernel.org>
Date: Thu, 22 Aug 2013 17:04:45 +0100
In-Reply-To: <20130822174121.18441b7f@x220>
References: <20130822174121.18441b7f@x220>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20096.005
X-TM-AS-Result: No--17.275500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-22 at 17:41 +0200, Udo Steinberg wrote:
> Hi all,
> 
> I'm running Linux 3.10.7 and have encountered the following NULL pointer
> dereference. So far it has only occurred once, so I cannot reproduce the
> circumstances that cause the problem.
> 
> Please keep me on CC: as I'm not subscribed to LKML.
[...]

Probably fixed by:

commit c319d50bfcf678c2857038276d9fab3c6646f3bf
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Tue Jul 30 22:34:28 2013 +0200

    nl80211: fix another nl80211_fam.attrbuf race

which went into 3.10.8.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

