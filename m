Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbaG3Ri3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 13:38:29 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51804 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371AbaG3Ri1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 13:38:27 -0400
Message-ID: <53D92D92.4090403@cogentembedded.com>
Date: Wed, 30 Jul 2014 21:38:26 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Debabrata Banerjee <dbanerje@akamai.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
CC: Julian Anastasov <ja@ssi.bg>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp: don't require root to read tcp_metrics
References: <1406740415-9386-1-git-send-email-dbanerje@akamai.com>
In-Reply-To: <1406740415-9386-1-git-send-email-dbanerje@akamai.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/30/2014 09:13 PM, Debabrata Banerjee wrote:

> commit d23ff701643a4a725e2c7a8ba2d567d39daa29ea introduced netlink support for

    Please also specify that commit's summary line in parens.

> the new tcp_metrics, however it restricted getting of tcp_metrics to root user
> only. This is a change from how these values could have been fetched when in
> the old route cache. Unless there's a legitimate reason to restrict the reading
> of these values it would be better if normal users could fetch them.

> Cc: Julian Anastasov <ja@ssi.bg>
> Cc: linux-kernel@vger.kernel.org

    You need to sign off on the patch, else it couldn't be applied.

WBR, Sergei

