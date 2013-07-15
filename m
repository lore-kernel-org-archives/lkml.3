Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334Ab3GOX3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 19:29:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52884 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab3GOX27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 19:28:59 -0400
Message-ID: <51E485B8.5050502@wwwdotorg.org>
Date: Mon, 15 Jul 2013 17:28:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
CC: balbi@ti.com, linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH v2 0/9] Tegra USB cleanup series
References: <1373918029-28977-1-git-send-email-ttynkkynen@nvidia.com>
In-Reply-To: <1373918029-28977-1-git-send-email-ttynkkynen@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 01:53 PM, Tuomas Tynkkynen wrote:
> Hi,
> 
> Here's a V2 of the few cleanup patches for the Tegra USB drivers, to be applied
> on top of Mikko's two patch sets. It mostly deals with removing all usage of
> platform data and using standard helpers and enums instead of Tegra-specific
> ones.

The series,
Reviewed-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>

... although I think you'll have to wait until Mikko's two series are
applied, since this is based on them. I'll finalize the patch
dependencies for the Tegra DT changes in Mikko's series tomorrow.
