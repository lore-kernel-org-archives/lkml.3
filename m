Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbaEAOGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 10:06:30 -0400
Received: from blu0-omc1-s17.blu0.hotmail.com ([65.55.116.28]:35425 "EHLO
	blu0-omc1-s17.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806AbaEAOG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 10:06:29 -0400
X-TMN: [FlB920zGe4ZS6WO2qCwo0OrgESEuru50]
X-Originating-Email: [dave.anglin@bell.net]
Message-ID: <BLU0-SMTP100F3609C6E4E30484E98DE97400@phx.gbl>
Date: Thu, 1 May 2014 10:06:51 -0400
From: John David Anglin <dave.anglin@bell.net>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Helge Deller <deller@gmx.de>, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-metag@vger.kernel.org
Subject: Re: [PATCH] parisc,metag: Do not hardcode maximum userspace stack
 size
References: <20140430212602.GA20601@p100.fritz.box>
In-Reply-To: <20140430212602.GA20601@p100.fritz.box>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 May 2014 14:06:27.0343 (UTC) FILETIME=[8B2249F0:01CF6546]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/30/2014 5:26 PM, Helge Deller wrote:
> This patch makes the stack size configurable and uses 80MB as default
> value which has been in use during the last few years on parisc and
> which didn't showed any problems yet.
>
> Signed-off-by: Helge Deller<deller@gmx.de>
> Cc:linux-parisc@vger.kernel.org
> Cc:linux-metag@vger.kernel.org
> Cc: John David Anglin<dave.anglin@bell.net>
>
I tested this version of the patch last night on 3.14.2.  I can
confirm that an 80MB region is reserved for stack at the expected
location in virtual memory with the default config setting.  GCC
and many other packages have built successfully with this setting.

Tested-by: John David Anglin <dave.anglin@bell.net>

---

Dave

-- 
John David Anglin    dave.anglin@bell.net

