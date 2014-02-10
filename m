Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaBJQrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:47:06 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:43548 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaBJQrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:47:04 -0500
Message-ID: <52F90281.2000705@wwwdotorg.org>
Date: Mon, 10 Feb 2014 09:46:57 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/17] i2c: i2c-tegra: deprecate class based instantiation
References: <1392026654-5343-1-git-send-email-wsa@the-dreams.de> <1392026654-5343-17-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1392026654-5343-17-git-send-email-wsa@the-dreams.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2014 03:04 AM, Wolfram Sang wrote:
> Warn users that class based instantiation is going away soon in favour
> of more robust probing and faster bootup times.

Acked-by: Stephen Warren <swarren@nvidia.com>

