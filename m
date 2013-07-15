Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037Ab3GOQtv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 12:49:51 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58719 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab3GOQtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 12:49:49 -0400
Message-ID: <51E4282B.5040905@wwwdotorg.org>
Date: Mon, 15 Jul 2013 10:49:47 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: thierry.reding@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] ARM: tegra: enable gpio-keys on dalmore
References: <1373439643-16633-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1373439643-16633-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 01:00 AM, Laxman Dewangan wrote:
> Dalmore have the keys mounted on board which are connected
> to different pins of Tegra.
> 
> Add the keys entry in DTS file to enable key functionality.
> This will enable KEY_POWER, KEY_HOME, KEY_VOLUMEUP and
> KEY_VOLUMEDOWN.

I have applied this to Tegra's for-3.12/dt branch.
