Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab3CSOGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:06:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:38580 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134Ab3CSOGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:06:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,872,1355126400"; 
   d="scan'208";a="304477138"
Message-ID: <1363702041.14966.20.camel@sauron.fi.intel.com>
Subject: Re: [PATCH -next] UBIFS: fix missing unlock on error in
 ubifs_remount_rw()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: adrian.hunter@intel.com, yongjun_wei@trendmicro.com.cn,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 19 Mar 2013 16:07:21 +0200
In-Reply-To: <CAPgLHd8Uj4-OWahuXSMxcb4Z3siukbveTm=bWNO1toatPwwcmg@mail.gmail.com>
References: <CAPgLHd8Uj4-OWahuXSMxcb4Z3siukbveTm=bWNO1toatPwwcmg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 11:12 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Add the missing unlock before return from function ubifs_remount_rw()
> in the error handling case.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thanks, I fixed this up in linux-ubifs.git.

-- 
Best Regards,
Artem Bityutskiy

