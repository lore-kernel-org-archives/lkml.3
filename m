Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbbAORbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 12:31:17 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:55406 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbbAORbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 12:31:15 -0500
Message-ID: <54B7F9A1.9020004@wwwdotorg.org>
Date: Thu, 15 Jan 2015 10:32:17 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>, linux-tegra@vger.kernel.org
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Dylan Reid <dgreid@chromium.org>, Simon Glass <sjg@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Chris Ball <chris@printf.net>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH v2 08/11] mmc: pwrseq_simple: Add support for a delay
References: <1421338359-27467-1-git-send-email-tomeu.vizoso@collabora.com> <1421338359-27467-9-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1421338359-27467-9-git-send-email-tomeu.vizoso@collabora.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2015 09:12 AM, Tomeu Vizoso wrote:
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

Some explanation of why such a delay might be useful would be ... useful!
