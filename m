Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab3BUQYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 11:24:09 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:50511 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab3BUQYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 11:24:05 -0500
MIME-Version: 1.0
In-Reply-To: <1361389302-11968-5-git-send-email-khilman@linaro.org>
References: <1361389302-11968-1-git-send-email-khilman@linaro.org>
	<1361389302-11968-5-git-send-email-khilman@linaro.org>
Date: Thu, 21 Feb 2013 17:24:03 +0100
Message-ID: <CAFTL4hxW8WmyTLCtzJoRt0TCqHe1nPUdRkepBy8rzfDBS_wnMQ@mail.gmail.com>
Subject: Re: [RFC/PATCH 4/5] cputime: use do_div() for nsec resolution
 conversion helpers
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Mats Liljegren <mats.liljegren@enea.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/20 Kevin Hilman <khilman@linaro.org>:
> For the nsec resolution conversions to be useful on non 64-bit
> architectures, do_div() needs to be used for the 64-bit divisions.
>
> Signed-off-by: Kevin Hilman <khilman@linaro.org>
> ---

The patch looks good. I'll run and apply it if everything's fine.
