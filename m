Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbaDGHMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 03:12:21 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:65493 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbaDGHMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 03:12:18 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfssBdxSQsWl79a/t4PfV4U932GyXoXM0xo7EoWRGQ==
X-RZG-CLASS-ID: mo00
Date: Mon, 7 Apr 2014 09:06:12 +0200
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, apw@canonical.com,
        jasowang@redhat.com, hpa@zytor.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] x86/platform/hyperv: When on Hyper-v use NULL legacy
 PIC
Message-ID: <20140407070612.GA7168@aepfle.de>
References: <1396574193-12043-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1396574193-12043-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, K. Y. Srinivasan wrote:

> +		printk(KERN_INFO "HyperV: Using null_legacy_pic\n");

Maybe this printk can be removed as well, unless its valuable info.

Olaf
