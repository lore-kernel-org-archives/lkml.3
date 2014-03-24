Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaCXUje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:39:34 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:36011 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbaCXUjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:39:33 -0400
X-Auth-Info: L19UZLy5Gomkc1EyklblxSwbspRK8sykCTVSrMkTKIo=
From: Marek Vasut <marex@denx.de>
To: linux-mtd@lists.infradead.org
Subject: Re: New NAND driver
Date: Mon, 24 Mar 2014 21:39:30 +0100
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>, computersforpeace@gmail.com,
        angus.clark@st.com, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com
References: <20140324132446.GA21665@lee--X1>
In-Reply-To: <20140324132446.GA21665@lee--X1>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201403242139.30933.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 24, 2014 at 02:24:46 PM, Lee Jones wrote:
> Hi Brian,
> 
> Firstly I'd like to thank you for supporting the inclusion of ST's SPI
> NOR (FSM) driver. As promised I will convert it over to the new
> framework once it has been applied by your good self.
> 
> In the meantime however, I have a NAND driver which I need to
> submit. I wanted to give you a heads-up prior to sending it in case
> you had any special requests. FYI: Shoving it where the sun don't
> shine, is not a valid request by the way :). It's 2700 lines and I've
> split it over 47 patches for reviewing purposes.

One nand driver in 47 patches ? Whoa ;-)

Best regards,
Marek Vasut
