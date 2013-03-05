Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab3CESX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 13:23:26 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:65516 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756501Ab3CESXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 13:23:25 -0500
Message-ID: <1362507803.16460.100.camel@x61.thuisdomein>
Subject: Re: [PATCH] ARM: dove: Fix typo "COMMON_CLK_DOVE"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Jason Cooper <jason@lakedaemon.net>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date: Tue, 05 Mar 2013 19:23:23 +0100
In-Reply-To: <20130305190232.0b1a5e29@armhf>
References: <1362476098.16460.65.camel@x61.thuisdomein>
	 <20130305140025.GO23237@titan.lakedaemon.net>
	 <20130305190232.0b1a5e29@armhf>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2013 18:23:24.0271 (UTC) FILETIME=[86044FF0:01CE19CE]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-05 at 19:02 +0100, Jean-Francois Moine wrote:
> The .config contains CONFIG_COMMON_CLK=y naturally because MACH_DOVE
> selects PLAT_ORION_LEGACY which selects PLAT_ORION which selects
> COMMON_CLK.
> 
> So, "select COMMON_CLK" is not needed in ARCH_DOVE.

Thanks. Unless people object (because they prefer an explicit, though
superfluous, select of COMMON_CLK) I'll redo my patch.


Paul Bolle

