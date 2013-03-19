Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab3CSLX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 07:23:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:10132 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab3CSLXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 07:23:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,870,1355126400"; 
   d="scan'208";a="281555437"
Message-ID: <1363692295.14966.12.camel@sauron.fi.intel.com>
Subject: Re: linux-next: Tree for Mar 18 (mtdcore)
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 19 Mar 2013 13:24:55 +0200
In-Reply-To: <51478949.2080400@infradead.org>
References: <20130318161841.a8f926f51a0b00033e2ee94c@canb.auug.org.au>
	 <51478949.2080400@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 14:38 -0700, Randy Dunlap wrote:
> when CONFIG_PROC_FS is not enabled:

Thanks Randy, should be fixed now.

-- 
Best Regards,
Artem Bityutskiy

