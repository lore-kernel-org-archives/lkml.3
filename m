Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab3HFT2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 15:28:55 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43024 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509Ab3HFT2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 15:28:53 -0400
Message-ID: <52014E72.2070604@wwwdotorg.org>
Date: Tue, 06 Aug 2013 13:28:50 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: dmitry.torokhov@gmail.com, swarren@nvidia.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: tegra: use dt-binding header for key code
References: <1375798370-2231-1-git-send-email-ldewangan@nvidia.com> <1375798370-2231-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1375798370-2231-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 08:12 AM, Laxman Dewangan wrote:
> In place of hardcoding the key code in DTS file and comment the key code
> as side notes, use the key code macro defines in the dt-bindings/input/input.h
> directly.

This one also looks fine to me. I'll wait for an updated version that
converts everything once patch 1/2 is accepted/applied.
