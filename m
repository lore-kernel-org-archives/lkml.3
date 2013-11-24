Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab3KXPOX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 10:14:23 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:38073 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab3KXPOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 10:14:22 -0500
Message-ID: <529217C7.6030304@cogentembedded.com>
Date: Sun, 24 Nov 2013 19:14:15 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>, linux-kernel@vger.kernel.org
CC: Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mm: nobootmem: avoid type warning about alignment value
References: <1385249326-9089-1-git-send-email-santosh.shilimkar@ti.com>
In-Reply-To: <1385249326-9089-1-git-send-email-santosh.shilimkar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 24-11-2013 3:28, Santosh Shilimkar wrote:

> Building ARM with NO_BOOTMEM generates below warning. Using min_t

    Where is that below? :-)

> to find the correct alignment avoids the warning.

> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

WBR, Sergei


