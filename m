Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361AbaFWBLM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:11:12 -0400
Received: from mga14.intel.com ([192.55.52.115]:11857 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbaFWBLK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:11:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,526,1400050800"; 
   d="scan'208";a="551777493"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Martin Kepplinger <martink@posteo.de>
CC: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [BUG] rc1 and rc2: Laptop unusable: on boot,screen black
 instead of native resolution
Thread-Topic: [BUG] rc1 and rc2: Laptop unusable: on boot,screen black
 instead of native resolution
Thread-Index: AQHPjiXLo0UUQDKQN0iPs7YO7EKItJt94jsw
Date: Mon, 23 Jun 2014 01:10:57 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B90926301379B97@SHSMSX101.ccr.corp.intel.com>
References: <53A6E72A.9090000@posteo.de>
In-Reply-To: <53A6E72A.9090000@posteo.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Martin Kepplinger [mailto:martink@posteo.de]
> Sent: Sunday, June 22, 2014 10:25 PM
> To: Zhang, Rui
> Cc: rjw@rjwysocki.net; lenb@kernel.org; linux-acpi@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: [BUG] rc1 and rc2: Laptop unusable: on boot,screen black
> instead of native resolution
> Importance: High
> 
> Since 3.16-rc1 my laptop's just goes black while booting, instead of
> switching to native screen resolution and showing me the starting
> system there. It's an Acer TravelMate B113 with i915 driver and
> acer_wmi. It stays black and is unusable.
> 
> Do you have other people complain about that? Bisecting didn't lead to
> a good result. I could be wrong but I somehow suspect the mistake to be
> somewhere in commit 99678ed73a50d2df8b5f3c801e29e9b7a3e5aa85
> 
In order to confirm if the problem is introduced by the above commit,
why not checkout the kernel just before and after this commit and see if the problem exists?

Thanks,
rui


> There is nothing unusual in the kernel log.
> 
> This is quite unusual for an -rc2. Hence my question. I'm happy to test
> changes.
> 
>                                      martin
> --
> Martin Kepplinger
> e-mail        martink AT posteo DOT at
> chat (XMPP)   martink AT jabber DOT at
