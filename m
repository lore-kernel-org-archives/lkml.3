Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422808Ab3CWAz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 20:55:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51095 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422667Ab3CWAz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 20:55:58 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1363998796.8972.69.camel@schen9-DESK>
References: <cover.1363961999.git.tim.c.chen@linux.intel.com> <1363987742.8972.55.camel@schen9-DESK> <09e94963-5146-4c1b-ab76-64ac73d660ab@email.android.com> <1363998796.8972.69.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 01/11] Added macro to check for AVX2 feature.
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 22 Mar 2013 17:55:38 -0700
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S.Miller" <davem@davemloft.net>,
        Kirk Yap <kirk.s.yap@intel.com>, David Cote <david.m.cote@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Message-ID: <7243684e-3017-4519-8758-651618da609f@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just syntactic overhead.  We should probably discuss it among ourselves first though.

Tim Chen <tim.c.chen@linux.intel.com> wrote:

>On Fri, 2013-03-22 at 17:21 -0700, H. Peter Anvin wrote:
>> I really, really hate these macros... Not sure they are worth the
>extra noise.
>> 
>
>I can do without the macro and I'll remove it.
>
>Wonder the reason that such macro should be avoided?
>
>Tim

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
