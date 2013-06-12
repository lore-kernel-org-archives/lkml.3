Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab3FLH11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 03:27:27 -0400
Received: from s72.web-hosting.com ([198.187.29.21]:42295 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab3FLH10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 03:27:26 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20920.8752.339655.254147@gargle.gargle.HOWL>
Date: Wed, 12 Jun 2013 12:54:32 +0530
To: David Miller <davem@davemloft.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-06-06
In-Reply-To: <20130612.002103.916991474696226731.davem@davemloft.net>
References: <20130606190929.GB18827@tuxdriver.com>
	<20130611.222706.1492583255605214982.davem@davemloft.net>
	<20130612.002103.916991474696226731.davem@davemloft.net>
X-Mailer: VM 8.2.0b under 24.3.50.2 (x86_64-unknown-linux-gnu)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server72.web-hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - msujith.org
X-Get-Message-Sender-Via: server72.web-hosting.com: authenticated_id: sujith@msujith.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> John, I also don't like the ATK9K Kconfig option name change added in
> this pull request, this is exactly the kind of thing that drives
> Linus insane.
> 
> Change the default, fine, but changing the name is unnecssary churn
> and adds a new config prompt that people are going to respond to
> incorrectly when they type "make oldconfig"

This was Linus' suggestion: https://patchwork.kernel.org/patch/2676971/

The RH bugzilla appears to be down at the moment, but more background
for the bug is here: https://bugzilla.redhat.com/show_bug.cgi?id=927191

Sujith
