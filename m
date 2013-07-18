Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899Ab3GRMR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 08:17:59 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:62608 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758206Ab3GRMR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 08:17:58 -0400
Message-ID: <1374149876.14303.8.camel@x61.thuisdomein>
Subject: Re: [kconfig] results of some syntactical checks
From: Paul Bolle <pebolle@tiscali.nl>
To: Martin Walch <walch.martin@web.de>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 18 Jul 2013 14:17:56 +0200
In-Reply-To: <98150748.1bixKSE5hB@tacticalops>
References: <7121962.G9xfZAqBSy@tacticalops>
	 <1374016680.26384.22.camel@x61.thuisdomein>
	 <1374042658.26384.31.camel@x61.thuisdomein>
	 <98150748.1bixKSE5hB@tacticalops>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jul 2013 12:17:56.0932 (UTC) FILETIME=[D6122840:01CE83B0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-17 at 15:07 +0200, Martin Walch wrote:
> All this can be avoided by quoting values, i. e.
> 
> 	range "8260" "8272"
> 
> and
> 
>         default "4711"

Documentation/kbuild/kconfig-language.txt even states
    Constant symbols are always surrounded by single or double quotes.

But apparently the parser doesn't care. All "range" digits are unquoted,
and most "default" digits are unquoted.

> Also, avoiding integers (and hex values) as symbol names looks like a 
> reasonable idea.

I was actually surprised that these were allowed, and only discovered
that when my local script generated a few false positives. But, anyhow,
in practice those symbol names seem to work just fine.


Paul Bolle

