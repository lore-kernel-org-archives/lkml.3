Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018Ab3CHSC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 13:02:27 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16234 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917Ab3CHSCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 13:02:23 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 08 Mar 2013 10:02:22 -0800
Message-ID: <513A274A.4030709@nvidia.com>
Date: Fri, 8 Mar 2013 23:30:42 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: DT: tegra20/tegra30: Correct clock id for UARTB
References: <1362751245-32432-1-git-send-email-ldewangan@nvidia.com> <513A2433.2080002@wwwdotorg.org>
In-Reply-To: <513A2433.2080002@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 March 2013 11:17 PM, Stephen Warren wrote:
> On 03/08/2013 07:00 AM, Laxman Dewangan wrote:
>> UARTB clock bit in CAR register is 7. Correcting this
>> in DTS file.
> The register bit is 7, but the clock ID in the Tegra CAR DT binding is
> 96 for UART2 or 97 for VFIR. This was due to there being 1 clock bit and
> 2 separate IP block reset bits, or the other way around, so we highlight
> the issue by assigning different clock IDs. See the comment before the
> list of clock IDs in the binding document.

Aaha, I missed the Documentation part. I was looking for DT entry only 
found this.



