Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab3K3FaV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 00:30:21 -0500
Received: from dmz-mailsec-scanner-4.mit.edu ([18.9.25.15]:65070 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751097Ab3K3FaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 00:30:17 -0500
X-AuditID: 1209190f-b7fb86d000000c36-c2-529977e873e0
Date: Sat, 30 Nov 2013 00:30:14 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] random: simplify loop in random_read
Message-ID: <20131130053014.GG8043@ringworld.MIT.EDU>
References: <cover.1384329436.git.price@mit.edu>
 <20131113080740.GR16018@ringworld.MIT.EDU>
 <20131129200905.GD3778@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131129200905.GD3778@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsUixG6nrvuifGaQwYG5BhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStj4pu3TAVHmSpub77A3MDYxNTFyMkhIWAisWDXGShbTOLCvfVs
	XYxcHEICs5kkVvXPYYZwNjJK9HxZzwrh/GKUeHt4G3sXIwcHi4CqxOfNGSDdbAIKEj/mr2MG
	CYsIOEo0vgMbKixgK3G7pRsszCtgKtHRkQoxpZFRovXQfFaQGl4BQYmTM5+wgNjMAloSN/69
	ZAKpZxaQllj+jwMkzCmgJ3F7xjFmEFtUQEViysltbBMYBWYh6Z6FpHsWQvcCRuZVjLIpuVW6
	uYmZOcWpybrFyYl5ealFuiZ6uZkleqkppZsYQcHIKcm/g/HbQaVDjAIcjEo8vBavZwQJsSaW
	FVfmHmKU5GBSEuU1KJkZJMSXlJ9SmZFYnBFfVJqTWnyIUYKDWUmEd5EHUI43JbGyKrUoHyYl
	zcGiJM57k8M+SEggPbEkNTs1tSC1CCYrw8GhJMErDow6IcGi1PTUirTMnBKENBMHJ8hwHqDh
	Z8pAhhcXJOYWZ6ZD5E8xKkqJ8/4BSQiAJDJK8+B6YcniFaM40CvCvHwgK3iAiQau+xXQYCag
	we++TgMZXJKIkJJqYLSvKHOe/GGO6sUlPpvVNWsOcK3hLgx3PFjMUJcm9+rm2fbfc49f9dY3
	nf9L7mj66vqni0Pu8xTIaPgLVx9uEll7Iitkz8+NHO1Pns858fHgRNGQ7TU9lz8GNFrGGLxY
	V/nartNU4V/REXmNN5X5bwpd7bb5unb72X6fkiW2dvOtWc07HT4KX1JiKc5INNRiLipOBAAb
	hEHc8QIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 03:09:05PM -0500, Theodore Ts'o wrote:
> Applied, although I slightly edited the commit description the the
> debug message mentioned in the description was removed since the first
> version of your patch series, and it wasn't updated as part of the
> rebase.

Ah, good catch.  Thanks!

Greg
