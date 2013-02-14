Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761523Ab3BNRyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:54:33 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:48140 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758259Ab3BNRyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:54:31 -0500
Message-ID: <511D24D4.6070805@wwwdotorg.org>
Date: Thu, 14 Feb 2013 10:54:28 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: linux-tegra@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ARM: dt: add header to define tegra20 clocks
References: <1360791198-29462-1-git-send-email-swarren@wwwdotorg.org> <1360823899-17846-1-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1360823899-17846-1-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2013 11:38 PM, Hiroshi Doyu wrote:
> To replace magic number in "clocks = <&tegra_car 28>;"

I like the concept here; I was thinking about doing this today, but you
beat me to it:-) Feel free to create the Tegra30 header too, and modify
all the *.dts* files.

To address other comments in this thread: Yes, I think that we will want
to modify the clock driver to include this header to avoid
duplication/errors (that will require adjusting Linux's include path),
and also remove the list of IDs from the binding document; it can just
refer the the new header by name and cause the header to *be* part of
the binding document.
