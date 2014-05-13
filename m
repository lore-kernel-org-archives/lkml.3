Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933953AbaEMOzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:55:38 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38930 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933752AbaEMOzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:55:36 -0400
Message-ID: <5372325B.7080106@ti.com>
Date: Tue, 13 May 2014 23:55:23 +0900
From: Milo Kim <milo.kim@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/16] mfd: lp3943: Make mfd_cell array const
References: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com> <1399978733-13662-6-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1399978733-13662-6-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 07:58 PM, Krzysztof Kozlowski wrote:
> mfd_add_devices() expects array of struct mfd_cell to be const.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Milo Kim <milo.kim@ti.com>

Acked-by: Milo Kim <milo.kim@ti.com>

Thanks!
