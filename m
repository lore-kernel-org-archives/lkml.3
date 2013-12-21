Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab3LUQW2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 11:22:28 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:35764 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab3LUQW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 11:22:26 -0500
Message-ID: <52B5C034.50800@linux.com>
Date: Sat, 21 Dec 2013 17:22:12 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, trivial@kernel.org,
        linux-kernel@vger.kernel.org, tj@kernel.org, lizefan@huawei.com,
        rob@landley.net
CC: linux-doc@vger.kernel.org
Subject: Re: [PATCH] [trivial] doc: cgroups: Fix typo in doc/cgroups
References: <1387641453-13803-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1387641453-13803-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

spotted one more typo.

On 12/21/2013 04:57 PM, Masanari Iida wrote:
> diff --git a/Documentation/cgroups/resource_counter.txt b/Documentation/cgroups/resource_counter.txt
> index c4d99ed..52e1da1 100644
> --- a/Documentation/cgroups/resource_counter.txt
> +++ b/Documentation/cgroups/resource_counter.txt
> @@ -97,8 +97,8 @@ to work with it.
>  		(struct res_counter *rc, struct res_counter *top,
>  		 unsinged long val)
                 ^^^^^^^^^^ should be unsigned.

-- 
Regards,
Levente Kurusa
