Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab3CLMTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 08:19:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33253 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068Ab3CLMTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 08:19:49 -0400
Date: Tue, 12 Mar 2013 12:16:13 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Danny Huang <dahuang@nvidia.com>
Cc: swarren@wwwdotorg.org, hdoyu@nvidia.com, olof@lixom.net,
        gregkh@linuxfoundation.org, arnd@arndb.de, josephl@nvidia.com,
        pdeschrijver@nvidia.com, pgaikwad@nvidia.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: tegra: expose chip ID and revision
Message-ID: <20130312121613.GT4977@n2100.arm.linux.org.uk>
References: <1363089667-15737-1-git-send-email-dahuang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363089667-15737-1-git-send-email-dahuang@nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 08:01:07PM +0800, Danny Huang wrote:
> +	if (IS_ERR_OR_NULL(soc_dev))

Sigh.  NAK.  Fur cryin out loud!  Use the IS_ERR() version.

And you don't need the following "return;" statement - that's already
implied at the closing brace of a function.
