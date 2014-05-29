Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465AbaE2TXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:23:03 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44847 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbaE2TXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:23:00 -0400
Message-ID: <53878911.9090508@wwwdotorg.org>
Date: Thu, 29 May 2014 13:22:57 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/5] efuse driver for Tegra
References: <1401281677-32110-1-git-send-email-pdeschrijver@nvidia.com> <20140528061645.252c2fbc.akpm@linux-foundation.org>
In-Reply-To: <20140528061645.252c2fbc.akpm@linux-foundation.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 07:16 AM, Andrew Morton wrote:
> On Wed, 28 May 2014 15:54:32 +0300 Peter De Schrijver <pdeschrijver@nvidia.com> wrote:
> 
>> This driver allows userspace to read the raw efuse data.
> 
> The patchset uses an inexplicable mixture of "fuse" and "efuse".
> Given that the kernel already has a "fuse", it would be nice if
> this code could use "efuse" everywhere.

I didn't check every instance, but a mix of those two terms seems
reasonable. "fuse" is the type of HW object; it's a generic HW term that
exists outside the scope of this patch. While the conflict with Linux's
filesystem is unfortunate, it's a name collision that I think we'll
simply have to live with; it's not created by this patch. "efuse" is the
name of the Tegra module that hosts Tegra's fuses.
