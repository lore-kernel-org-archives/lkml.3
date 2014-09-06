Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbaIFTGd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 15:06:33 -0400
Received: from [83.145.59.141] ([83.145.59.141]:15427 "EHLO
	stoexhubfe02.domain01.net" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751887AbaIFTGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 15:06:31 -0400
Date: Sat, 6 Sep 2014 21:05:35 +0200
From: Anders Darander <anders@chargestorm.se>
To: Matt Fleming <matt@console-pimps.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v4] x86: only load initrd above 4g on second try
Message-ID: <20140906190534.GA4767@ad.chargestorm.se>
References: <1409806207-3992-1-git-send-email-yinghai@kernel.org>
 <20140904100137.GK3001@console-pimps.org>
 <5408D299.5000300@zytor.com>
 <20140905221616.GP3001@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140905221616.GP3001@console-pimps.org>
X-Accept-Language: sv, en, de
X-GPG-Fingerprint: 5AF0 B2E9 78FE 9D75 D110  6F8F 3E31 84D7 920E 938C
X-GPG-Key-Id: 0x920E938C
X-GPG-Keyserver: hkp://keys.gnupg.net
Organization: ChargeStorm AB
User-Agent: Mutt/1.5.23 (2014-03-12)
X-GFI-SMTP-Submission: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matt Fleming <matt@console-pimps.org> [140906 00:16]:

> On Thu, 04 Sep, at 01:59:05PM, H. Peter Anvin wrote:

> > I am fine with this patch, but at the same time I do want to note that
> > there is an alternative to double-buffer the patch and/or (if that
> > applies to the buggy BIOS) round up the size of the target buffer.

> I took a whack at the double-buffer strategy, and I think the patch is
> conceptually pretty straight forward.

> Could someone try out the following patch? It works around the problem
> on my ASUS machine.

Your patch works around the problem on my Dell machine also. With that
one applied, it boots fine!

Thus, 

Tested-by: Anders Darander <anders@chargestorm.se>

Cheers,
Anders

-- 
All the troubles you have will pass away very quickly.
