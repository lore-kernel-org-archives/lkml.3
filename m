Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422690Ab3CWAd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 20:33:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:47086 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932325Ab3CWAd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 20:33:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,895,1355126400"; 
   d="scan'208";a="283444595"
Subject: Re: [PATCH 01/11] Added macro to check for AVX2 feature.
From: Tim Chen <tim.c.chen@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S.Miller" <davem@davemloft.net>,
        Kirk Yap <kirk.s.yap@intel.com>, David Cote <david.m.cote@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
In-Reply-To: <09e94963-5146-4c1b-ab76-64ac73d660ab@email.android.com>
References: <cover.1363961999.git.tim.c.chen@linux.intel.com>
	 <1363987742.8972.55.camel@schen9-DESK>
	 <09e94963-5146-4c1b-ab76-64ac73d660ab@email.android.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Mar 2013 17:33:16 -0700
Message-ID: <1363998796.8972.69.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-22 at 17:21 -0700, H. Peter Anvin wrote:
> I really, really hate these macros... Not sure they are worth the extra noise.
> 

I can do without the macro and I'll remove it.

Wonder the reason that such macro should be avoided?

Tim

