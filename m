Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbbAPTmD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 14:42:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:46129 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755480AbbAPTmA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 14:42:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,412,1418112000"; 
   d="scan'208";a="671232757"
From: "Vick, Matthew" <matthew.vick@intel.com>
To: Xander Huff <xander.huff@ni.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Williams, Mitch A" <mitch.a.williams@intel.com>
CC: Linux NICS <Linux-nics@isotope.jf.intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jeff.westfahl@ni.com" <jeff.westfahl@ni.com>,
        "Fujinaka, Todd" <todd.fujinaka@intel.com>
Subject: Re: [PATCH RESEND] igb: Reset TXPBSIZE to default value
Thread-Topic: [PATCH RESEND] igb: Reset TXPBSIZE to default value
Thread-Index: AQHQMb7Od3J6scTQL0GR9X8HxaM9MZzDJX0A
Date: Fri, 16 Jan 2015 19:41:59 +0000
Message-ID: <D0DEA929.671EB%matthew.vick@intel.com>
References: <1421434779-20586-1-git-send-email-xander.huff@ni.com>
In-Reply-To: <1421434779-20586-1-git-send-email-xander.huff@ni.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.4.7.141117
x-originating-ip: [10.166.14.15]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2815939F00305243919A51C2BD802613@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/16/15, 10:59 AM, "Xander Huff" <xander.huff@ni.com> wrote:

>From: Jeff Westfahl <jeff.westfahl@ni.com>
>
>The TXPBSIZE register of the i210 resets to its default value only
>at power-on. It doesn't reset if you reboot the system, only if you
>pull power. If something (another driver, another OS, etc.) modifies
>this register from its default value, the igb driver doesn't function
>correctly. It detects a hang of the transmitter and continuously resets
>the adapter. Here we set this value to its default when resetting the
>i210 to resolve this issue.

This should have already been resolved last May in commit
27dff8b2f680ce966b5d959be9d69dd0edd92e3b ("igb: add defaults for i210
TX/RX PBSIZE"). Are you running the latest upstream kernel?

Cheers,
Matthew

