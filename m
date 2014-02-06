Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbaBFQvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 11:51:31 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:53567 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaBFQv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:51:29 -0500
Message-ID: <52F3BD8C.3020208@wwwdotorg.org>
Date: Thu, 06 Feb 2014 09:51:24 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Chew <achew@nvidia.com>, wim@iguana.be, rob@landley.net,
        thierry.reding@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        abrestic@chromium.org, dgreid@chromium.org, katierh@chromium.org
CC: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 1/1] watchdog: Add tegra watchdog
References: <1391657913-28608-1-git-send-email-achew@nvidia.com>
In-Reply-To: <1391657913-28608-1-git-send-email-achew@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2014 08:38 PM, Andrew Chew wrote:
> Add a driver for the hardware watchdogs in NVIDIA Tegra SoCs (Tegra30 and
> later).  This driver will configure one watchdog timer that will reset the
> system in the case of a watchdog timeout.
> 
> This driver binds to the nvidia,tegra30-timer device node and gets its
> register base from there.

Can you provide some instructions on how to test this patch on Tegra
boards? Please make sure those instructions are on our internal upstream
testing wiki page too; I'll mail you the link internally.
