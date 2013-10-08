Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab3JHGg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 02:36:26 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2591 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab3JHGgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 02:36:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 07 Oct 2013 23:36:23 -0700
Message-ID: <5253ADBB.2040009@nvidia.com>
Date: Tue, 8 Oct 2013 12:31:15 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial: tegra: remove deprecated IRQF_DISABLED
References: <1381041017-12806-1-git-send-email-michael.opdenacker@free-electrons.com> <5252EA3F.9090101@wwwdotorg.org>
In-Reply-To: <5252EA3F.9090101@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 October 2013 10:37 PM, Stephen Warren wrote:
> On 10/06/2013 12:30 AM, Michael Opdenacker wrote:
>> This patch proposes to remove the use of the IRQF_DISABLED flag
>>
>> It's a NOOP since 2.6.35 and it will be removed one day.
> Laxman, care to comment? I'm not sure why the code explicitly specifies
> IRQF_DISABLED if it's already a no-op. Perhaps the code expects
> IRQF_DISABLED to do something, and hence there's some bug that needs to
> be fixed because of it doesn't?
>

We are having this flag in our downstream driver from very long and 
hence this is there when I wrote for the upstream driver. I checked with 
BT without this flag and it worked fine so it is fine to remove this flag.

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
