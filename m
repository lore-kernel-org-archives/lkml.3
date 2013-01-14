Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab3ANQp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 11:45:57 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:43173 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001Ab3ANQpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 11:45:55 -0500
Message-ID: <50F43640.7060308@wwwdotorg.org>
Date: Mon, 14 Jan 2013 09:45:52 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFT 3/3] ARM: tegra: dts: seaboard: enable keyboard
References: <1357911185-11048-1-git-send-email-ldewangan@nvidia.com> <1357911185-11048-3-git-send-email-ldewangan@nvidia.com> <50F09BC7.90607@wwwdotorg.org> <20130111232438.GN23505@n2100.arm.linux.org.uk> <50F09FCB.70809@wwwdotorg.org> <20130111233615.GO23505@n2100.arm.linux.org.uk> <50F0A2A8.3080401@wwwdotorg.org> <50F13C34.3020808@nvidia.com>
In-Reply-To: <50F13C34.3020808@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2013 03:34 AM, Laxman Dewangan wrote:
...
> Which is the tree on which Prashant changes are applied. I can debug
> from that tree.

git://nv-tegra.nvidia.com/user/swarren/linux-2.6 test-ccf-rework-v4

But as I said in some other email in response to Prashant, I'll go and
find out why the clk driver is returning NULL.

(Russell, while the clk API definition may allow NULL to be a legal clk
value, the actual implementation on Tegra at least doesn't consider NULL
to be a legal clk value, so it shouldn't be returned in the first
place). There's no issue here in the comprehension of the clk API.
