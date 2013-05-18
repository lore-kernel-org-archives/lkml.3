Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab3ERCXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:23:04 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:57419 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757549Ab3ERCW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:22:58 -0400
Message-ID: <5196E601.10202@prisktech.co.nz>
Date: Sat, 18 May 2013 14:22:57 +1200
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        romieu@fr.zoreil.com, netdev@vger.kernel.org
Subject: Re: [PATCHv6 0/3] Add support for velocity network driver on platform
 devices
References: <1368768078-16121-1-git-send-email-linux@prisktech.co.nz> <20130517.141938.2120801813213703422.davem@davemloft.net> <20130517.173644.1877140985770026320.davem@davemloft.net>
In-Reply-To: <20130517.173644.1877140985770026320.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-7; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/05/13 12:36, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Fri, 17 May 2013 14:19:38 -0700 (PDT)
>
>> Series applied, thanks.
> I'm reverting this, you're not using the correct types for the PM
> functions you're hooking up.
>
> drivers/net/ethernet/via/via-velocity.c:3238:8: warning: initialization from incompatible pointer type [enabled by default]
> drivers/net/ethernet/via/via-velocity.c:3238:8: warning: (near initialization for ¡velocity_pm_ops.suspend¢) [enabled by default]
> drivers/net/ethernet/via/via-velocity.c:3238:8: warning: initialization from incompatible pointer type [enabled by default]
> drivers/net/ethernet/via/via-velocity.c:3238:8: warning: (near initialization for ¡velocity_pm_ops.freeze¢) [enabled by default]
> drivers/net/ethernet/via/via-velocity.c:3238:8: warning: initialization from incompatible pointer type [enabled by default]
> drivers/net/ethernet/via/via-velocity.c:3238:8: warning: (near initialization for ¡velocity_pm_ops.poweroff¢) [enabled by default]
Argh.. sorry Dave.
I forgot to merge the fixup for this before sending. Fixed version to 
follow.

Regards
Tony P
