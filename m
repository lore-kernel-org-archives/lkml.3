Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab3LCUJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 15:09:24 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41691 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab3LCUJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 15:09:22 -0500
Message-ID: <529E3A6E.1050003@wwwdotorg.org>
Date: Tue, 03 Dec 2013 13:09:18 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>, rob.herring@calxeda.com
CC: pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk, thierry.reding@gmail.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: tegra: convert device tree file of Dalmore to
 use pinctrl defines
References: <1385992502-12771-1-git-send-email-ldewangan@nvidia.com> <1385992502-12771-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1385992502-12771-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 06:55 AM, Laxman Dewangan wrote:
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Patch description?

BTW, did you compile all the Tegra DT files before and after this
change, and make sure that there's zero difference between them (i.e.
they're identical byte-for-byte when compiled)? I don't feel like
manually double-checking this entire patch...
