Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbaIVTFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 15:05:45 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55662 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaIVTFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 15:05:44 -0400
Message-ID: <5420731E.6040104@wwwdotorg.org>
Date: Mon, 22 Sep 2014 13:06:06 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Vidya Sagar <vidyas@nvidia.com>
CC: thierry.reding@gmail.com, ldewangan@nvidia.com, kthota@nvidia.com,
        linux-tegra@vger.kernel.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] ARM: tegra: Fix sd4 regulator in Jetson TK1 device
 tree
References: <1411408675-32315-1-git-send-email-vidyas@nvidia.com>
In-Reply-To: <1411408675-32315-1-git-send-email-vidyas@nvidia.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2014 11:57 AM, Vidya Sagar wrote:
> sd4 is an always on regulator which is turned on at boot time.
> It is externally controller through gpio. This change
> reflects the same in Jetson TK1 device tree

In the schematics, the "Power Sequencing" timing diagram says "S/W 
controlled" for SD4/+1.05V_RUN. I also don't see an "ENABLE1" pin on the 
AS3722, which would be required for ...

> +					ams,ext-control = <1>;

... to be valid.

What's the source of information behind this change?

What symptoms does this patch correct?
