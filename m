Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab3KEMMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 07:12:48 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:61327 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab3KEMMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 07:12:46 -0500
X-Nat-Received: from [202.181.97.72]:57375 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1383653548.3756
To: zohar@linux.vnet.ibm.com, jim.epost@gmail.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, james.l.morris@oracle.com,
        linux-security-module@vger.kernel.org
Subject: Re: randconfig build error with next-20131104, in security/integrity
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <CA+r1Zhir86Mdmps5N1awK7mJxf1CWgkr-RDKYVhmpj_3+oYyYQ@mail.gmail.com>
	<1383606829.15186.25.camel@dhcp-9-2-203-236.watson.ibm.com>
In-Reply-To: <1383606829.15186.25.camel@dhcp-9-2-203-236.watson.ibm.com>
Message-Id: <201311052112.DCC60296.MFOOFSOHJVtLQF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 5 Nov 2013 21:12:26 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 05112013 #9885645, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar wrote:
> @@ -132,24 +133,22 @@ static inline int integrity_digsig_verify(const unsigned int id,
>  	return -EOPNOTSUPP;
>  }
>  
> +static int integrity_init_keyring(const unsigned int id)

Please add inline keyword, or compiler makes noisy warning.

> +{
> +	return 0;
> +}
>  #endif /* CONFIG_INTEGRITY_SIGNATURE */
