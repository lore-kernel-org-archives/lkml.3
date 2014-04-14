Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbaDNNIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 09:08:40 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:65359 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbaDNNIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 09:08:38 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfssBY5SQsSl9CXp8arK9v39HhxlZ/qveXkfVo4YvQ==
X-RZG-CLASS-ID: mo00
Date: Mon, 14 Apr 2014 15:08:22 +0200
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: x86@kernel.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com, jasowang@redhat.com,
        tglx@linutronix.de, hpa@zytor.com, JBeulich@suse.com
Subject: Re: [PATCH V2 1/1] X86: Probe for PIC and set legacy_pic
 appropriately
Message-ID: <20140414130822.GA24197@aepfle.de>
References: <1397282200-10143-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1397282200-10143-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, K. Y. Srinivasan wrote:

> Probe for the existance of legacy PIC, if one does not exist, use the
> null_legacy_pic.

> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Tested-by: Olaf Hering <olaf@aepfle.de>

Fixes the crash on Gen1 VMs for me, which was introduced by
"x86/platform/hyperv: When on Hyper-v use NULL legacy PIC".

Olaf
