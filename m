Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab3IWEFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 00:05:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39183 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab3IWEE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 00:04:59 -0400
Message-ID: <523FBD9F.7080704@zytor.com>
Date: Sun, 22 Sep 2013 21:03:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        joern@logfs.org, macro@linux-mips.org, ralf@linux-mips.org,
        dave.taht@gmail.com, blogic@openwrt.org, andrewmcgr@gmail.com,
        smueller@chronox.de, geert@linux-m68k.org, tg@mirbsd.de,
        "H. Peter Anvin" <hpa@linux.intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH, RFC 03/12] random: Allow fractional bits to be tracked
References: <1379882338-7209-1-git-send-email-tytso@mit.edu> <1379882338-7209-4-git-send-email-tytso@mit.edu> <20130923040148.GG7321@thunk.org>
In-Reply-To: <20130923040148.GG7321@thunk.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 09:01 PM, Theodore Ts'o wrote:
> I've added the following changes to this patch since upon testing,
> there were some uses of r->entropy_count that were not properly
> converted from using fractional bits to bits.
> 

Thanks for catching that.

	-hpa


