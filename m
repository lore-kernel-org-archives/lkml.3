Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab3AOUN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 15:13:29 -0500
Received: from xes-mad.com ([216.165.139.218]:64390 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993Ab3AOUN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 15:13:28 -0500
Message-ID: <50F5B863.3070203@xes-inc.com>
Date: Tue, 15 Jan 2013 14:13:23 -0600
From: Aaron Sierra <asierra@xes-inc.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: =?ISO-8859-1?Q?Ag=F3cs_P=E1l?= <agocs.pal.86@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] lpc_ich: fix gpio base and control offsets
References: <a858277c-6164-4d43-abee-a3d34ad8b04c@zimbra>
In-Reply-To: <a858277c-6164-4d43-abee-a3d34ad8b04c@zimbra>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 01:12 PM, Aaron Sierra wrote:

>   static int lpc_ich_acpi_save = -1;
>   static int lpc_ich_gpio_save = -1;
> +static unsigned long lpc_ich_chipset = -1;
All,
Any concerns apart from my nonsense of assigning -1 to an unsigned type?

Agócs,
Does this patch still perform as you expect?

-- 
--- Extreme Engineering Solutions, Inc (X-ES) ---
Aaron Sierra
X-ES http://www.xes-inc.com
3225 Deming Way, Ste 120
Middleton, WI  53562
Phone: (608) 833-1155 x115
Email: asierra@xes-inc.com

