Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab3BGXqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 18:46:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59535 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab3BGXqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 18:46:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH 0/4] Improve CLKSRC_OF matching
Date: Thu, 7 Feb 2013 23:45:52 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Warren <swarren@wwwdotorg.org>
References: <1360264144-20714-1-git-send-email-robherring2@gmail.com> <201302072244.51588.arnd@arndb.de> <51143A87.4040205@gmail.com>
In-Reply-To: <51143A87.4040205@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302072345.52195.arnd@arndb.de>
X-Provags-ID: V02:K0:ey4NGPEo8SaEpkDoMWUN2sxf+GccA7uhBgoQdk27XEd
 o4bEpA/J4WW1fNZfxrgyMWwm35LAbbz3FW/J0+DWXSMcgSOwBw
 tPZOfIdqTsvpw/okuPojWZ7sldV3JwNyV0afO6ziJeT71RtJXa
 HlmS74YjAfzQp6A4+wGh0Plg15Ykmd5iuqPkR7ooeNYA8JZu9F
 U4mcm0niGMnE4ctJ5mZc+FP36zXC7eoeft+FVpsShTUDtBaK7S
 Seu2ceZoCPlQCgsKpyNyl11kZoZVDlBLbNM4v7y7BwdACG25Wk
 vMg+FlaeV5giR/c3JnLbM8XhXdqjL4uy9Dr4xeYOwVTgsIa2FM
 ppQUNwF+C6z5u/hGaHVA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2013, Rob Herring wrote:
> How so? I don't see a warning as there is no type checking on the init
> function since of_device_id.data is just a void *. It would be good to
> have type checking here if you know a way, but I don't.

Ah, that's right. So it silently builds find even though the
prototypes don't match, and given the C calling conventions
it even ends up working correctly, it just feels wrong.

	Arnd
