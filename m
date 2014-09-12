Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbaILHST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 03:18:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56678 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbaILHSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 03:18:17 -0400
Message-ID: <54129E32.2080703@ti.com>
Date: Fri, 12 Sep 2014 12:48:10 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Nishanth Menon <nm@ti.com>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ARM: dts: dra7: Add CPSW and MDIO module nodes
 for dra7
References: <1410356247-25925-1-git-send-email-mugunthanvnm@ti.com> <1410356247-25925-2-git-send-email-mugunthanvnm@ti.com> <5410573B.5010907@ti.com> <54114339.5070404@ti.com> <20140911212956.GC17692@csclub.uwaterloo.ca>
In-Reply-To: <20140911212956.GC17692@csclub.uwaterloo.ca>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 September 2014 02:59 AM, Lennart Sorensen wrote:
> I have the mac but I don't want to use both ports on the 2 port switch.
> In fact in our case ethernet1 is a pru_eth interface.  Can a board dts
> override the alias for ethernet1 or is that a syntax error?  I don't
> think I tried that yet.

You can override it in board dts file

Regards
Mugunthan V N
