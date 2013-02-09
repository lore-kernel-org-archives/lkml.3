Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab3BIAkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 19:40:23 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:51124 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932195Ab3BIAkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 19:40:21 -0500
Message-ID: <1360370419.13487.8.camel@joe-AO722>
Subject: Re: [PATCH] MAINTAINERS: add keyword "tegra" to Tegra section
From: Joe Perches <joe@perches.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: arm@kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Date: Fri, 08 Feb 2013 16:40:19 -0800
In-Reply-To: <1360353891-24210-1-git-send-email-swarren@wwwdotorg.org>
References: <1360353891-24210-1-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-08 at 13:04 -0700, Stephen Warren wrote:
> (?<!in)tegra

This doesn't work well.   It matches too many
words like integral.

I suggest

K:	(?:\btegra\b|\bTEGRA_)

