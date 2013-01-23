Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab3AWQN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 11:13:29 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:35039 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371Ab3AWQN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 11:13:28 -0500
Message-ID: <51000C23.2040002@wwwdotorg.org>
Date: Wed, 23 Jan 2013 09:13:23 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: alan@linux.intel.com, gregkh@linuxfoundation.org, jslaby@suse.cz,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [PATCH] serial: tegra: Fix compilation error
References: <1358925733-20206-1-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1358925733-20206-1-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2013 12:22 AM, Venu Byravarasu wrote:
> Fix compilation error, by adding the correct header file
> for Tegra clocks.

Uggh. I guess this driver did introduce new users of the Tegra reset
control APIs, which didn't get converted by the Tegra clock patches
since they went through a different tree:-(

Reviewed-by: Stephen Warren <swarren@nvidia.com>
