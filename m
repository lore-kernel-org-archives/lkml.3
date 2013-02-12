Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760969Ab3BLAQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 19:16:15 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:60391 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760145Ab3BLAQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 19:16:14 -0500
Message-ID: <1360628172.4707.10.camel@joe-AO722>
Subject: Re: [PATCH V3 1/2] get_maintainer: allow keywords to match filenames
From: Joe Perches <joe@perches.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: arm@kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Julian Andres Klode <jak@jak-linux.org>,
        Marc Dietrich <marvin24@gmx.de>, Stephen Warren <swarren@nvidia.com>
Date: Mon, 11 Feb 2013 16:16:12 -0800
In-Reply-To: <5119880C.8010602@wwwdotorg.org>
References: <1360626016-23332-1-git-send-email-swarren@wwwdotorg.org>
	 <1360627226.4707.6.camel@joe-AO722> <5119880C.8010602@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-11 at 17:08 -0700, Stephen Warren wrote:
> Does "that" above mean "not setting exact_pattern_match_hash", or
> "changing the patch so that it does set exact_pattern_match_hash". Sorry...

I think what you have is fine.


