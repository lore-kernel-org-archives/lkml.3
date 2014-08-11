Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbaHKRAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 13:00:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46373 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaHKRAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 13:00:07 -0400
Message-ID: <53E8F6A4.2040500@wwwdotorg.org>
Date: Mon, 11 Aug 2014 11:00:20 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Kiran Padwal <kiran.padwal21@gmail.com>, linus.walleij@linaro.org
CC: thierry.reding@gmail.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] pinctrl: tegra124: Make of_device_id array const
References: <1407765741-3846-1-git-send-email-kiran.padwal21@gmail.com>
In-Reply-To: <1407765741-3846-1-git-send-email-kiran.padwal21@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2014 08:02 AM, Kiran Padwal wrote:
> Make of_device_id array const, because all OF functions handle it as const.

The series,
Acked-by: Stephen Warren <swarren@nvidia.com>

