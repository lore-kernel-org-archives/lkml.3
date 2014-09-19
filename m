Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629AbaISSgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 14:36:40 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:54871 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626AbaISSgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 14:36:38 -0400
Message-ID: <1411151793.5129.50.camel@marge.simpson.net>
Subject: Re: Kernel bug 60770
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Len Brown <len.brown@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Ian Malone <ibmalone@gmail.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Date: Fri, 19 Sep 2014 20:36:33 +0200
In-Reply-To: <541C58B0.4060704@hurleysoftware.com>
References: <CA+5PVA4Ld3-VfPN6NWk=uqiuG2p99dL8Ro_X08NFb33_UtnWMA@mail.gmail.com>
	 <CA+5PVA5XxcQe+Coy-OdMRsAxSCH=3B7QdsdXO2GqRkFDcAt0iA@mail.gmail.com>
	 <1409234000.5212.7.camel@marge.simpson.net>
	 <541C58B0.4060704@hurleysoftware.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-19 at 12:24 -0400, Peter Hurley wrote:

> Mike,
> 
> The changes for clflush don't build prior to 3.17-rcX;
> X86_BUG_CLFLUSH_MONITOR was X86_FEATURE_CLFLUSH_MONITOR prior to
> commit 9b13a93df267af681a66a6a738bf1af10102da7d,
> 'x86, cpufeature: Convert more "features" to bugs'.

Yeah, you have to bend adjust a little depending what kernel you want to
not suck on these old processors.

-Mike

