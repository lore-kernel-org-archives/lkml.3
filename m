Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab3EKUbZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 16:31:25 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:34397 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab3EKUbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 16:31:24 -0400
Message-ID: <518EAAA6.2030301@cogentembedded.com>
Date: Sun, 12 May 2013 00:31:34 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC 17/42] drivers/net/ethernet/renesas: don't check resource
 with devm_ioremap_resource
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de> <1368173847-5661-18-git-send-email-wsa@the-dreams.de> <518CD501.1040909@cogentembedded.com>
In-Reply-To: <518CD501.1040909@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/10/2013 03:07 PM, Sergei Shtylyov wrote:

>
>> devm_ioremap_resource does sanity checks on the given resource. No 
>> need to
>> duplicate this in the driver.
>
>> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
>
> Acked-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

     I was too fast, I'm now withdawing my ACK.

> WBR, Sergei
>

WBR, Sergei

