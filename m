Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbaFWLcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 07:32:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:17100 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbaFWLb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 07:31:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,529,1400050800"; 
   d="scan'208";a="561829201"
Message-ID: <1403523115.7903.64.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] Add security.selinux XATTR support for the UBIFS. Also
 fix couple of bugs in UBIFS extended attribute length calculation.
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Subodh Nijsure <subodh.nijsure@gmail.com>
Cc: linux-mtd@lists.infradead.org, Adrian Hunter <adrian.hunter@intel.com>,
        linux-kernel@vger.kernel.org, Subodh Nijsure <snijsure@grid-net.com>
Date: Mon, 23 Jun 2014 14:31:55 +0300
In-Reply-To: <1333892851-10758-1-git-send-email-snijsure@grid-net.com>
References: <1333892851-10758-1-git-send-email-snijsure@grid-net.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-08 at 06:47 -0700, Subodh Nijsure wrote:
> TESTING: Tested on  MX28 based platforms using Micron MT29F2G08ABAEAH4 NAND
>          With these change we are able to label UBIFS filesystem with security.selinux
>          and run system with selinux enabled.
>          Also ran integck test on UBI filesystem.
> 
> Signed-off-by: Subodh Nijsure <snijsure@grid-net.com>

Hi,

it looks like more people are interested in SELinux support. What
happened to this stuff?  You did not seem to take it all the way to
upstream for some reasons.

-- 
Best Regards,
Artem Bityutskiy

