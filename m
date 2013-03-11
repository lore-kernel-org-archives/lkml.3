Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab3CKUcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:32:47 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56112 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752462Ab3CKUcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:32:46 -0400
Message-ID: <1363033964.2056.49.camel@joe-AO722>
Subject: Re: [PATCH V3] get_maintainer: use filename-only regex match for
 Tegra
From: Joe Perches <joe@perches.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Lucas Stach <dev@lynxeye.de>, Borislav Petkov <bp@alien8.de>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Date: Mon, 11 Mar 2013 13:32:44 -0700
In-Reply-To: <1363033149-7839-1-git-send-email-swarren@wwwdotorg.org>
References: <1363033149-7839-1-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 14:19 -0600, Stephen Warren wrote:
> Create a new N: entry type in MAINTAINERS which performs a regex match
> against filenames; either those extracted from patch +++ or --- lines,
> or those specified on the command-line using the -f option.
[]
> Switch the Tegra entry from using K: to N:

Acked-by: Joe Perches <joe@perches.com>


