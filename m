Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760877Ab3BLACv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 19:02:51 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:56700 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760679Ab3BLACu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 19:02:50 -0500
Message-ID: <1360627368.4707.8.camel@joe-AO722>
Subject: Re: [PATCH V3 2/2] MAINTAINERS: update Tegra section to capture all
 Tegra files
From: Joe Perches <joe@perches.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: arm@kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Julian Andres Klode <jak@jak-linux.org>,
        Marc Dietrich <marvin24@gmx.de>, Stephen Warren <swarren@nvidia.com>
Date: Mon, 11 Feb 2013 16:02:48 -0800
In-Reply-To: <1360626016-23332-2-git-send-email-swarren@wwwdotorg.org>
References: <1360626016-23332-1-git-send-email-swarren@wwwdotorg.org>
	 <1360626016-23332-2-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-11 at 16:40 -0700, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> The intent is to ensure that all Tegra-related patches are sent to the
> linux-tegra@ mailing list, so people can keep up-to-date on all misc
> driver changes.
> 
> Doing this with a keyword is far simpler and more compact than listing
> all Tegra-related drivers, even if wildcards were used.
> 
> Words such as integrate or integrator are common. Ensure the character
> right before "tegra" isn't a-z (case-insensitive), to make sure the
> keyword doesn't match those.
> 
> The only files that the keyword doesn't match are the NVEC driver. Add
> the linux-tegra mailing list to the NVEC entry to solve this.

You should probably add some commentary/documentation
to the K: section description of MAINTAINERS in patch 1/2.

Something about K: patterns also matching filenames.

	K: Keyword perl extended regex pattern to match content in a
	   patch or file.  For instance:
	   K: of_get_profile
	      matches patches or files that contain "of_get_profile"
	   K: \b(printk|pr_(info|err))\b
	      matches patches or files that contain one or more of the words
	      printk, pr_info or pr_err
	   One regex pattern per line.  Multiple K: lines acceptable.


