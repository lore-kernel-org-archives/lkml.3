Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab3HNNvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:51:09 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:39494 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759804Ab3HNNvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:51:07 -0400
Message-ID: <520B8B45.1010300@baylibre.com>
Date: Wed, 14 Aug 2013 15:51:01 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
CC: linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uri.y@variscite.com, nm@ti.com
Subject: Re: [PATCH v2 0/2] omap4/twl6030: typical connection to omap4 as
 a separate dtsi file
References: <1376469348-10797-1-git-send-email-ruslan.bilovol@ti.com>
In-Reply-To: <1376469348-10797-1-git-send-email-ruslan.bilovol@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ruslan,

On 14/08/2013 10:35, Ruslan Bilovol wrote:
> Hello,
>
> There is no functional changes between v1 and v2 - just
> added the patch for omap4-var-som - Uri Yosef confirmed
> this board have the same connection of OMAP4<->TWL6030 as
> SDP4430 board

The series looks good to me, but it will be good to have a test for 
Panda and Variscite boards before merging it.

Regards,
Benoit

