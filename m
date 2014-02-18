Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291AbaBROgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:36:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42189 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756276AbaBROg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:36:27 -0500
Message-ID: <53036FBD.8030307@zytor.com>
Date: Tue, 18 Feb 2014 06:35:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
CC: sam@ravnborg.org, x86@kernel.org, linux-kbuild@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 13/20] Kbuild, lto: Set TMPDIR for LTO v2
References: <1392733738-8290-1-git-send-email-andi@firstfloor.org> <1392733738-8290-14-git-send-email-andi@firstfloor.org>
In-Reply-To: <1392733738-8290-14-git-send-email-andi@firstfloor.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 06:28 AM, Andi Kleen wrote:
>  
> +ifdef CONFIG_LTO
> +# LTO gcc creates a lot of files in TMPDIR, and with /tmp as tmpfs
> +# it's easy to drive the machine OOM. Use the object directory
> +# instead
> +TMPDIR ?= ${objtree}
> +export TMPDIR
> +endif
> +

We still prefer $(...) in Makefiles, no?

	-hpa


