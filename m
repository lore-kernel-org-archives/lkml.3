Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaB1VNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 16:13:43 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:49562 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751682AbaB1VNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:13:42 -0500
Message-ID: <1393622017.4052.5.camel@x220>
Subject: Re: [PATCH] blackfin: bf537: fix typo "CONFIG_SND_SOC_ADV80X_MODULE"
From: Paul Bolle <pebolle@tiscali.nl>
To: Steven Miao <realmz6@gmail.com>
Cc: bfin <adi-buildroot-devel@lists.sourceforge.net>,
        "open list:CAN NETWORK DRIVERS <linux-can@vger.kernel.org>, open "
	 "list:NETWORKING DRIVERS <netdev@vger.kernel.org>, open list" 
	<linux-kernel@vger.kernel.org>
Date: Fri, 28 Feb 2014 22:13:37 +0100
In-Reply-To: <CAMk6uBnjEA2eozct6Q_Cm2BCrF-_3gGuNaBmtymGKYpPjoLUVw@mail.gmail.com>
References: <1362744373.5994.57.camel@x61.thuisdomein>
	 <1392284459.30853.17.camel@x220>
	 <CAMk6uBnjEA2eozct6Q_Cm2BCrF-_3gGuNaBmtymGKYpPjoLUVw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Feb 2014 21:13:40.0566 (UTC) FILETIME=[F41D3760:01CF34C9]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven,

On Wed, 2014-02-26 at 18:35 +0800, Steven Miao wrote:
> On Thu, Feb 13, 2014 at 5:40 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> >> 1) There are many lines that might be converted to IS_ENABLED() in this
> >> file. I'm not sure if and how that should be done.
> Sorry for the late reply. There are many CONFIG_xxx ||
> CONFIG_xxx_MODULE things, we need a cleanup for it under all the
> stamp.c and ezkit.c.

Should I draft a patch to do that? And should that patch include this
patch, or is this patch finally getting pushed (after some testing, that
is)?

Thanks,


Paul Bolle

