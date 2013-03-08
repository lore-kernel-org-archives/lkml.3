Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934532Ab3CHRrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 12:47:36 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:58555 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933577Ab3CHRrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 12:47:35 -0500
Message-ID: <513A2433.2080002@wwwdotorg.org>
Date: Fri, 08 Mar 2013 10:47:31 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: DT: tegra20/tegra30: Correct clock id for UARTB
References: <1362751245-32432-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1362751245-32432-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 07:00 AM, Laxman Dewangan wrote:
> UARTB clock bit in CAR register is 7. Correcting this
> in DTS file.

The register bit is 7, but the clock ID in the Tegra CAR DT binding is
96 for UART2 or 97 for VFIR. This was due to there being 1 clock bit and
2 separate IP block reset bits, or the other way around, so we highlight
the issue by assigning different clock IDs. See the comment before the
list of clock IDs in the binding document.
