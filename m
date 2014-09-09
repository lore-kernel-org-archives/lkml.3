Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068AbaIIOvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:51:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58326 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756991AbaIIOvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:51:08 -0400
Date: Tue, 9 Sep 2014 16:51:03 +0200
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, thomas.petazzoni@free-electrons.com,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] net: mvberlin_eth: add an Ethernet driver for
 Marvell Berlin
Message-ID: <20140909145103.GA15973@kwain>
References: <1409320263-10295-1-git-send-email-antoine.tenart@free-electrons.com>
 <1409320263-10295-2-git-send-email-antoine.tenart@free-electrons.com>
 <20140829145145.GA7735@arch.cereza>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140829145145.GA7735@arch.cereza>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ezequiel,

On Fri, Aug 29, 2014 at 11:51:45AM -0300, Ezequiel Garcia wrote:
> Hi Antoine,
> 
> A quick look...

Well, it seems Sebastian is right and we can use the existing PXA168
Ethernet driver, so I just sent a new series doing that...

Thanks for the review anyway!

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
