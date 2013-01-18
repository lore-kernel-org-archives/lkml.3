Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3ARTg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:36:57 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41591 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab3ARTgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:36:55 -0500
Message-ID: <50F9A453.2000600@wwwdotorg.org>
Date: Fri, 18 Jan 2013 12:36:51 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: gregkh@linuxfoundation.org, stern@rowland.harvard.edu, balbi@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3 4/4] usb: Add APIs to access host registers from Tegra
 PHY
References: <1358489737-32273-1-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1358489737-32273-1-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2013 11:15 PM, Venu Byravarasu wrote:
> As Tegra PHY driver needs to access one of the Host registers,
> added few APIs.

I have applied patches 1-3 (v1) and patch 4 (v3) to Tegra's for-3.9/usb
branch.
