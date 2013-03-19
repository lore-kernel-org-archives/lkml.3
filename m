Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490Ab3CSSFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 14:05:15 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37180 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933258Ab3CSSFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 14:05:13 -0400
Message-ID: <5148A8D6.8000002@wwwdotorg.org>
Date: Tue, 19 Mar 2013 12:05:10 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Danny Huang <dahuang@nvidia.com>
CC: linux@arm.linux.org.uk, ldewangan@nvidia.com, pgaikwad@nvidia.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: fuse: add fuctions to read speedo id and
 process id
References: <1363660405-10668-1-git-send-email-dahuang@nvidia.com>
In-Reply-To: <1363660405-10668-1-git-send-email-dahuang@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2013 08:33 PM, Danny Huang wrote:
> Add functions to read the speedo and process id of both cpu and soc.
> There might be some drivers need the information as well.

What code wants to use these functions? It'd be best to submit this
patch with that code, so that something actually uses the functions, and
they don't look like dead code.

In the past, functions similar to this used to exist. However, they were
removed and replaced by direct access to the underlying variables. Do we
actually need functions for this, or can code simply read from the
variables instead?
