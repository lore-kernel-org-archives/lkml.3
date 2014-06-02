Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbaFBJjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:39:11 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:54486 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbaFBJjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:39:08 -0400
Date: Mon, 2 Jun 2014 11:35:32 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/5] ARM: Berlin: SMP support
Message-ID: <20140602093532.GF28090@lunn.ch>
References: <1401700866-24804-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401700866-24804-1-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 11:21:01AM +0200, Antoine Ténart wrote:
> This series adds the SMP support for Marvell Berlin BG2 and BG2Q.
> 
> This implementation takes advantage of the reset exception register and
> the software reset address register to make the CPUs execute the Berlin
> secondary startup when being being reseted. This has the advantage of

Hi Antoine.

One of these funny rules of English is that there is no word
'reseted'. It is just 'reset'. Also, one 'being' is enough!

	   Andrew
