Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbaLWO7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 09:59:43 -0500
Received: from mail-yk0-f176.google.com ([209.85.160.176]:35322 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209AbaLWO7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 09:59:42 -0500
Message-ID: <5499835B.508@ridgerun.com>
Date: Tue, 23 Dec 2014 08:59:39 -0600
From: Carsten Behling <carsten.behling@ridgerun.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: balbi@ti.com, linux-kernel@vger.kernel.org
Subject: Re: usb: musb: Scheduling of interrupt endpoints
References: <54947E99.4010908@ridgerun.com>
In-Reply-To: <54947E99.4010908@ridgerun.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Would it help if I send a patch as a suggestion and as basis for discussion?

On 12/19/2014 01:38 PM, Carsten Behling wrote:
> Hi all,
>
> Long time ago, TI shipped a kernel named 
> linux-2.6.32.17-psp03.01.01.39 with an additional kernel option
> for scheduling of interrupt endpoints.
>
> AFAIK, this seems to be the only possibility to attach more that 4 in 
> endpoints to MUSB (at least on a DM368).
>
> This feature reserves one hardware endpoint unit to time schedule 
> interrupt in endpoints based
> on its bInterval value triggered by the SOF interrupt.
>
> I didn't find any discussion about adding such a feature to the 
> mainline kernel.
> IMHO, this feature is absolutely necessary. But there may be reasons, 
> not to add it (e.g. CPU load).
>
> Please let me know your thoughts and ideas.
>
> Best regards
> -Carsten
>

