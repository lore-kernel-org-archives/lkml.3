Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab3JGGra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 02:47:30 -0400
Received: from etezian.org ([198.101.225.253]:60959 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab3JGGr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 02:47:29 -0400
Date: Mon, 7 Oct 2013 08:48:52 +0200
From: Andi Shyti <andi@etezian.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: Use of drivers/platform and matching include?
Message-ID: <20131007064852.GC5896@jack.whiskey>
References: <BC1C47B3-5412-4829-A1D9-AAB04694D1CC@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BC1C47B3-5412-4829-A1D9-AAB04694D1CC@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> As we look at upstreaming more support for the Qualcomm MSM SoCs there are a number of drivers or library like routines that are unique to the MSM platform, we are thinking that putting them under:

just a question, is this code the one you have already in
codeaurora for 8974/8226/8626/8610 etc?

Thanks,
Andi
