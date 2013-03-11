Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab3CKFtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 01:49:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39710 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab3CKFtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 01:49:45 -0400
Message-ID: <513D70E2.6030702@ti.com>
Date: Mon, 11 Mar 2013 11:21:30 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lokesh Vutla <lokeshvutla@ti.com>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 8/8] memory: emif: Load the correct custom config values
 from dt
References: <1362978365-5593-1-git-send-email-lokeshvutla@ti.com> <1362978365-5593-9-git-send-email-lokeshvutla@ti.com>
In-Reply-To: <1362978365-5593-9-git-send-email-lokeshvutla@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 March 2013 10:36 AM, Lokesh Vutla wrote:
> of_get_property returns value in Big Endian format.
> Before using this value it should be converted to little endian
> using be32_to_cpup().
> Custom configs of emif are read from dt using of_get_property,
> but these are not converted to litte endian format.
> Correcting the same here.
> 
> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
> ---
Looks fine.
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

