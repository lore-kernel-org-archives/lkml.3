Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbaA1QlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 11:41:22 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37964 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbaA1QlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 11:41:20 -0500
Message-ID: <52E7DDAD.1030309@wwwdotorg.org>
Date: Tue, 28 Jan 2014 09:41:17 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Manish Badarkhe <badarkhe.manish@gmail.com>, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: broonie@kernel.org, lgirdwood@gmail.com
Subject: Re: [PATCH V2] regulator: fixed: update to devm_* API
References: <1390878720-8676-1-git-send-email-badarkhe.manish@gmail.com>
In-Reply-To: <1390878720-8676-1-git-send-email-badarkhe.manish@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2014 08:12 PM, Manish Badarkhe wrote:
> Update the code to use devm_* API so that driver core will manage
> resources.

I'm not sure why this patch is sent to linux-tegra@vger.kernel.org; it
seems nothing to do with Tegra (or Samsung or OMAP for that matter).
