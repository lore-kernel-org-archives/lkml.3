Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbbAEWT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:19:58 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:54246 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbbAEWT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:19:57 -0500
Date: Mon, 5 Jan 2015 22:19:56 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Suman Anna <s-anna@ti.com>
cc: Lokesh Vutla <lokeshvutla@ti.com>, Roger Quadros <rogerq@ti.com>,
        tony@atomide.com, t-kristo@ti.com, nm@ti.com, nsekhar@ti.com,
        bcousson@baylibre.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP2+: hwmod: Fix _wait_target_ready() for hwmods
 without sysc
In-Reply-To: <54AAEBCC.2030900@ti.com>
Message-ID: <alpine.DEB.2.02.1501052219240.28771@utopia.booyaka.com>
References: <1418917790-1791-1-git-send-email-rogerq@ti.com> <5492F84E.7020706@ti.com> <alpine.DEB.2.02.1501020654050.27058@utopia.booyaka.com> <54AA4CD4.40105@ti.com> <54AAEBCC.2030900@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2015, Suman Anna wrote:

> That's right, the test was present even before 6423d6df1440, I merely
> made this a block.

Indeed, I misread the commit.  Sorry about ihat.


- Paul
