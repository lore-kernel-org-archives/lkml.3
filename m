Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaIYKLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 06:11:46 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:61915 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751589AbaIYKLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 06:11:45 -0400
Message-ID: <1411639902.7866.2.camel@x220>
Subject: Re: [PATCH] Hexagon: Remove useless select of NO_IOPORT_MAP
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 25 Sep 2014 12:11:42 +0200
In-Reply-To: <1411586511.19525.38.camel@x220>
References: <1411586511.19525.38.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Sep 2014 10:11:42.0532 (UTC) FILETIME=[1AA7F040:01CFD8A9]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-24 at 21:21 +0200, Paul Bolle wrote:
> Actually, the only difference I found in the .config file was that after
> this patch the .config file contained
>     CONFIG_HEXAGON=y
> 
> I have no idea why. Did I botch my test?

Apparently I did. Retested using next-20140925. There's no difference in
the .config file before and after the patch. That's a good thing! This
select really is useless.


Paul Bolle

