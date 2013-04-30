Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab3D3FC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 01:02:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:32941 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab3D3FC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 01:02:58 -0400
Message-ID: <517F5047.5040507@ti.com>
Date: Tue, 30 Apr 2013 10:31:59 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Gupta, Pekon" <pekon@ti.com>
CC: <linux-mtd@lists.infradead.org>, <b-cousson@ti.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, avinash philip <avinashphilip@ti.com>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <gururaja.hebbar@ti.com>, <hvaibhav@ti.com>, <zonque@gmail.com>,
        <jacmet@sunsite.dk>
Subject: Re: [v2,1/3] ARM: dts: AM33XX: Add ELM node
References: <7fa7438c9a7c5da575d762423815625d523c4689.1359007746.git.avinashphilip@ti.com>
In-Reply-To: <7fa7438c9a7c5da575d762423815625d523c4689.1359007746.git.avinashphilip@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/29/2013 1:23 PM, Gupta, Pekon wrote:
> From: avinash philip <avinashphilip@ti.com>
> 
> From: "Philip, Avinash" <avinashphilip@ti.com>

From: line is repeated twice.

> 
> Add ELM data node to AM33XX device tree file.
> 
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
> Tested-by: Pekon Gupta <pekon@ti.com>

You should add your sign-off (instead of tested-by) since you are now in
the submission path.

Thanks,
Sekhar
