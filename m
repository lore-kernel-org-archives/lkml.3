Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab3ISS0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 14:26:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39735 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab3ISS0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 14:26:16 -0400
Message-ID: <523B41C5.1050905@wwwdotorg.org>
Date: Thu, 19 Sep 2013 12:26:13 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: swarren@nvidia.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH REPOST] ARM: tegra: use dt-binding header for key code
References: <1379510552-23401-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1379510552-23401-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 07:22 AM, Laxman Dewangan wrote:
> In place of hardcoding the key code in DTS file and comment the
> key code as side notes, use the key code macro defines in the
> dt-bindings/input/input.h directly.

Applied to Tegra's for-3.13/dt branch.
