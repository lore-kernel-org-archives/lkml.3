Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab3GAVvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 17:51:08 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47338 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab3GAVvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 17:51:07 -0400
Message-ID: <51D1F9C7.8040500@wwwdotorg.org>
Date: Mon, 01 Jul 2013 15:51:03 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
CC: balbi@ti.com, linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH 4/9] ARM: tegra: Remove USB platform data
References: <1372455427-20898-1-git-send-email-ttynkkynen@nvidia.com> <1372455427-20898-5-git-send-email-ttynkkynen@nvidia.com>
In-Reply-To: <1372455427-20898-5-git-send-email-ttynkkynen@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2013 03:37 PM, Tuomas Tynkkynen wrote:
> USB-related platform data is not used anymore in the Tegra USB drivers,
> so remove all of it.

Acked-by: Stephen Warren <swarren@nvidia.com>
