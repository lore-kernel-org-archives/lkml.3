Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbaL3Ulq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 15:41:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53576 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbaL3Ulo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 15:41:44 -0500
Date: Tue, 30 Dec 2014 21:41:41 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "egrumbach@gmail.com" <egrumbach@gmail.com>,
        "peter@hurleysoftware.com" <peter@hurleysoftware.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: iwlwifi-driver card doesn't work with 3.19-rc2+
In-Reply-To: <1419971304.30412.0.camel@egrumbacBox>
Message-ID: <alpine.LNX.2.00.1412302135520.31609@pobox.suse.cz>
References: <alpine.LNX.2.00.1412301427430.31609@pobox.suse.cz>  <CANUX_P0=wJiKrR4cUgEN=LO+eQ2byprz0K9m9QxzJc+kf4+_bA@mail.gmail.com>  <54A2B807.1020202@hurleysoftware.com>  <0BA3FCBA62E2DC44AF3030971E174FB31B5DC915@hasmsx107.ger.corp.intel.com> 
 <alpine.LNX.2.00.1412301610320.31609@pobox.suse.cz> <1419971304.30412.0.camel@egrumbacBox>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2014, Grumbach, Emmanuel wrote:

> You should also have the iw tool which will provide all you need
> using the nl80211 interface which is now the preferred interface.

There indeed is an iw tool.

The thing is really as simple as -- userspace which is calling other 
wireless-utils directly (such as, but absolutely not limited to, wicd), 
will completely stop working after commit 24a0aa212e.

I am still convinced that 24a0aa212e needs to be reverted, and compat 
layer maintained for *much* longer than 2 years.

If wireless maintainers think otherwise, I'll send a revert request to 
Linus for consideration.

Thanks,

-- 
Jiri Kosina
SUSE Labs
