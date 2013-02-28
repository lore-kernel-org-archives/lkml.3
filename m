Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760449Ab3B1PQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:16:50 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:40896 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760382Ab3B1PQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 10:16:46 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJwKkjb5r/RwalLlLc=
X-RZG-CLASS-ID: mo00
Date: Thu, 28 Feb 2013 16:16:41 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org, kys@microsoft.com,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH RFC] video: Add Hyper-V Synthetic Video Frame Buffer
 Driver
Message-ID: <20130228151641.GA13552@aepfle.de>
References: <1360955396-14183-1-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1360955396-14183-1-git-send-email-haiyangz@microsoft.com>
User-Agent: Mutt/1.5.21.rev5638 (2013-02-08)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, Haiyang Zhang wrote:

> +	if (fb_get_options("hyperv_fb", &opt) || !opt || !*opt)

> +	strcpy(info->fix.id, "hyperv");


Here is a mismatch between video=<optname> and /proc/fb output.
Both should have the same string IMO.

Olaf
