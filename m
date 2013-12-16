Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab3LPWOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 17:14:47 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:42944 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab3LPWOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 17:14:42 -0500
Message-ID: <52AF7B4D.2010305@gmail.com>
Date: Mon, 16 Dec 2013 23:14:37 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: mturquette@linaro.org
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        jiada_wang@mentor.com, laurent.pinchart@ideasonboard.com,
        kyungmin.park@samsung.com
Subject: Re: [RESEND PATCH v7 1/5] omap3isp: Modify clocks registration to
 avoid circular references
References: <1386177127-2894-1-git-send-email-s.nawrocki@samsung.com> <1386177127-2894-2-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1386177127-2894-2-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Laurent has already taken this patch into his tree, could you apply
the remaining ones to your clk tree so this series has enough exposure
in -next ?

Thanks,
Sylwester
