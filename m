Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab3BQOc3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 09:32:29 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:36399 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388Ab3BQOc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 09:32:28 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJwKkjb5r/WwRxJgX0=
X-RZG-CLASS-ID: mo00
Date: Sun, 17 Feb 2013 15:32:23 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org, kys@microsoft.com,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH RFC] video: Add Hyper-V Synthetic Video Frame Buffer
 Driver
Message-ID: <20130217143223.GA11543@aepfle.de>
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

> +config HYPERV_FB

This should probably be FB_HYPERB to follow the naming of all other
drivers.

Olaf
