Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab3HAVRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:17:30 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60681 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab3HAVR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:17:28 -0400
Message-ID: <51FAD066.80902@wwwdotorg.org>
Date: Thu, 01 Aug 2013 15:17:26 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
CC: balbi@ti.com, linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu
Subject: Re: [PATCH 5/6] Documentation: New DT parameters for tegra30-usb-phy
References: <1375292522-7855-1-git-send-email-ttynkkynen@nvidia.com> <1375292522-7855-6-git-send-email-ttynkkynen@nvidia.com>
In-Reply-To: <1375292522-7855-6-git-send-email-ttynkkynen@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 11:42 AM, Tuomas Tynkkynen wrote:
> Document the new device tree parameters for Tegra30 USB PHY.

Very minor nit: It would make sense to move this patch before the
previous patch (or squash them together) so that the documentation is
updated first. But, it makes no difference to the code/git-bisect/...
