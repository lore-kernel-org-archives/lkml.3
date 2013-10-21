Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab3JUBUP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 21:20:15 -0400
Received: from void.printf.net ([89.145.121.20]:33380 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab3JUBUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 21:20:14 -0400
From: Chris Ball <cjb@laptop.org>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: bhelgaas@google.com, adrian.hunter@intel.com, wfp5p@virginia.edu,
        gregkh@linuxfoundation.org, g.liakhovetski@gmx.de,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2] mmc: sdhci-pci: add Intel Merrifield support
References: <1380658695-20047-1-git-send-email-david.a.cohen@linux.intel.com>
Date: Sun, 20 Oct 2013 21:19:58 -0400
In-Reply-To: <1380658695-20047-1-git-send-email-david.a.cohen@linux.intel.com>
	(David Cohen's message of "Tue, 1 Oct 2013 13:18:15 -0700")
Message-ID: <87hacba08x.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, Oct 01 2013, David Cohen wrote:
> Implement initial SDHCI Intel Merrifield support.
> This patch is based on previous one from Yunpeng Gao <yunpeng.gao@intel.com>
>
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>  drivers/mmc/host/sdhci-pci.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)

Thanks, pushed to mmc-next for 3.13.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
