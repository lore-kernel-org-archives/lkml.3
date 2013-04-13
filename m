Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab3DMTFp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 15:05:45 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34216 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751772Ab3DMTFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 15:05:43 -0400
Message-ID: <1365879943.2358.14.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: whitelist SUPPORTED_*/ADVERTISED_* defines
 from ethtool.h
From: Joe Perches <joe@perches.com>
To: Jonas Gorski <jogo@openwrt.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Date: Sat, 13 Apr 2013 12:05:43 -0700
In-Reply-To: <1365862257-31151-1-git-send-email-jogo@openwrt.org>
References: <1365862257-31151-1-git-send-email-jogo@openwrt.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-04-13 at 16:10 +0200, Jonas Gorski wrote:
> Don't complain about camelcase when using SUPPORTED_*/ADVERTISED_*
> defines, they are part of the user api so can't be (easily) fixed.

CamelCase was downgraded recently to a --strict test.

https://lkml.org/lkml/2013/4/11/273

Still, there's a large quantity of CamelCase names in
include/... that would still exist in any case.

A complete whitelist would be very long.

