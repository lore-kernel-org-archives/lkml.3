Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab3LCUE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 15:04:28 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46873 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab3LCUEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 15:04:16 -0500
Message-ID: <529E393C.4010604@wwwdotorg.org>
Date: Tue, 03 Dec 2013 13:04:12 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: rob.herring@calxeda.com, mark.rutland@arm.com, thierry.reding@gmail.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, ijc+devicetree@hellion.org.uk
Subject: Re: [PATCH] ARM: tegra: convert device tree files to use key defines
References: <1385989797-10879-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1385989797-10879-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 06:09 AM, Laxman Dewangan wrote:
> Use key code macros for all key code refernced for keys.
> 
> For tegra20-seaboard.dts and tegra20-harmony.dts:
>   The key comment for key (16th row and 1st column) is KEY_KPSLASH but
>   code is 0x004e which is the key code for KEY_KPPLUS. As there other
>   key exist with KY_KPPLUS, I am assuming key code is wrong and comment
>   is fine. With this assumption, I am keeping the key code as KEY_KPSLASH.

This looks reasonable, and I'll apply it soon. What is the patch based
on? Note that I recently sent a patch to fix the sort order of DT nodes
in all Tegra DT files, which I'll apply early since it's a cleanup, and
IIRC some of the KBC nodes may have been moved by that patch, so this
may conflict. I'll see if I can rebase while applying it.
