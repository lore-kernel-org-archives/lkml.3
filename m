Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbaLaIDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 03:03:30 -0500
Received: from s72.web-hosting.com ([198.187.29.22]:43561 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaLaID2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 03:03:28 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21667.44627.825091.517424@gargle.gargle.HOWL>
Date: Wed, 31 Dec 2014 13:35:39 +0530
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Larry Finger <Larry.Finger@lwfinger.net>,
        Borislav Petkov <bp@alien8.de>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "egrumbach\@gmail.com" <egrumbach@gmail.com>,
        "peter\@hurleysoftware.com" <peter@hurleysoftware.com>,
        "ilw\@linux.intel.com" <ilw@linux.intel.com>,
        "Berg\, Johannes" <johannes.berg@intel.com>,
        "johannes\@sipsolutions.net" <johannes@sipsolutions.net>
Subject: RE: iwlwifi-driver card doesn't work with 3.19-rc2+
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5DD429@hasmsx107.ger.corp.intel.com>
References: <alpine.LNX.2.00.1412301427430.31609@pobox.suse.cz>
	<CANUX_P0=wJiKrR4cUgEN=LO+eQ2byprz0K9m9QxzJc+kf4+_bA@mail.gmail.com>
	<54A2B807.1020202@hurleysoftware.com>
	<0BA3FCBA62E2DC44AF3030971E174FB31B5DC915@hasmsx107.ger.corp.intel.com>
	<alpine.LNX.2.00.1412301610320.31609@pobox.suse.cz>
	<1419971304.30412.0.camel@egrumbacBox>
	<alpine.LNX.2.00.1412302135520.31609@pobox.suse.cz>
	<20141230212326.GA29263@pd.tnic>
	<54A328C2.5080606@lwfinger.net>
	<alpine.LNX.2.00.1412302341290.31609@pobox.suse.cz>
	<0BA3FCBA62E2DC44AF3030971E174FB31B5DD429@hasmsx107.ger.corp.intel.com>
X-Mailer: VM 8.2.0b under 25.0.50.1 (x86_64-unknown-linux-gnu)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server72.web-hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - msujith.org
X-Get-Message-Sender-Via: server72.web-hosting.com: authenticated_id: sujith@msujith.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grumbach, Emmanuel wrote:
> I don't see this as another datapoint. All it means is that there are ancient
> drivers that won't work at all with newer tools and that are taken into
> consideration while trying to deprecate an API.

Not just drivers, tools and applications too.

I don't think we can ever lose the WEXT baggage since there will probably be
tools that will never migrate to nl80211. But, we can direct to /dev/null all
kernel bugs that are related to WEXT. :-)

Sujith
