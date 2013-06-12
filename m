Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab3FLVcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 17:32:08 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60360 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607Ab3FLVcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 17:32:07 -0400
Message-ID: <51B8E8D4.40506@wwwdotorg.org>
Date: Wed, 12 Jun 2013 15:32:04 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Rhyland Klein <rklein@nvidia.com>
CC: Anton Vorontsov <cbou@mail.ru>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] arm: tegra: Add power-supplies link between battery
 and charger
References: <1370899602-22123-1-git-send-email-rklein@nvidia.com> <1370899602-22123-5-git-send-email-rklein@nvidia.com>
In-Reply-To: <1370899602-22123-5-git-send-email-rklein@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 03:26 PM, Rhyland Klein wrote:
> The power supply core now supports detecting linkages between batteries
> and chargers through the use of the power-supplies property. Adding
> this to the battery, the core will use the phandle list to find
> the associated charger and pair them up. This facilitates notifications
> from the charger to the battery when ac power is dissconnected
> or connected for instance.

Applied to Tegra's for-3.11/dt branch.
