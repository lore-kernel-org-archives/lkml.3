Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab3AOQhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 11:37:24 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:51917 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308Ab3AOQhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 11:37:23 -0500
Message-ID: <50F585C0.20900@wwwdotorg.org>
Date: Tue, 15 Jan 2013 09:37:20 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: olof@lixom.net, arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com
Subject: Re: [PATCH] timer: vt8500: Convert vt8500 to use CLKSRC_OF
References: <1358232649-19964-1-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1358232649-19964-1-git-send-email-linux@prisktech.co.nz>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 11:50 PM, Tony Prisk wrote:
> This patch converts arch-vt8500 to make use of CLKSRC_OF. Doing so
> removes the need for include/linux/vt8500_timer.h as vt8500_timer_init
> no longer needs to be visible outside vt8500_timer.c

Reviewed-by: Stephen Warren <swarren@nvidia.com>
