Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab3JMLN3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 07:13:29 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47818 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab3JMLN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 07:13:28 -0400
Message-ID: <525A8053.9020409@gmail.com>
Date: Sun, 13 Oct 2013 13:13:23 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-media@vger.kernel.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: exynos4: index out of bounds if no pixelcode found
References: <alpine.DEB.2.02.1310131204550.11060@Z>
In-Reply-To: <alpine.DEB.2.02.1310131204550.11060@Z>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roel,

On 10/13/2013 12:16 PM, Roel Kluin wrote:
> In case no valid pixelcode is found, an i of -1 after the loop is out of
> bounds for the array.
>
> Signed-off-by: Roel Kluin<roel.kluin@gmail.com>

Thank you for the fix, I have applied this patch to my tree for 3.13.
However it seems to be mangled (at least line wrapped) and didn't
apply cleanly. The patchwork also didn't catch it properly:
https://patchwork.linuxtv.org/patch/20380/

I'd suggest using git send-email in future.

Thanks,
Sylwester
