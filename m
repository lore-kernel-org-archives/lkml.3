Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab3GVWYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 18:24:43 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:63274 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab3GVWYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 18:24:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130722211831.GA3304@krebstar.arl.arizona.edu>
References: <20130722211831.GA3304@krebstar.arl.arizona.edu>
Date: Mon, 22 Jul 2013 15:24:40 -0700
Message-ID: <CA+r1Zhjh646Ac95MFCrS2EB-ypLL9WV6CZH0CT0kmhUUkK2wuA@mail.gmail.com>
Subject: Re: randconfig build error with next-20130722, in net/netfilter
From: Jim Davis <jim.epost@gmail.com>
To: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, pablo@netfilter.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 2:18 PM, Jim Davis <jim.epost@gmail.com> wrote:
> Building with the attached random configuration file,
>
> net/built-in.o: In function `tproxy_tg_init':
> /home/jim/linux/net/netfilter/xt_TPROXY.c:415: undefined reference to `nf_defra$
> make: *** [vmlinux] Error 1

Yikes -- that's 'nf_defrag_ipv6_enable'
