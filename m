Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbaKSVod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:44:33 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:56001 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996AbaKSVo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:44:29 -0500
MIME-Version: 1.0
In-Reply-To: <1416276560-3363-1-git-send-email-slaoub@gmail.com>
References: <1416276560-3363-1-git-send-email-slaoub@gmail.com>
Date: Wed, 19 Nov 2014 13:44:28 -0800
Message-ID: <CA+8MBbJ-Vs_h2LXoVuzPmbTLsAGThhHR7UxoA56gNt4Lmjy27g@mail.gmail.com>
Subject: Re: [PATCH v4 0/2]RAS: add the support for handling UCNA/DEFERRED error
From: Tony Luck <tony.luck@gmail.com>
To: Chen Yucong <slaoub@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, Andi Kleen <ak@linux.intel.com>,
        aravind.gopalakrishnan@amd.com,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 6:09 PM, Chen Yucong <slaoub@gmail.com> wrote:
> V4:
> Like MCIP/RIPV/EIPV bits, MCI_STATUS_EN is specific to "machine check exception".
> As Tony suggested, the severity table entry for the "EN" check should have been
> skipped when calling from the CMCI/Poll handler.
>   Link: https://lkml.org/lkml/2014/11/11/765
>   AMD APM Volume 2: 9.3.2 Error-Reporting Register Banks - MCi_STATUS

I've put these in a "ucna" branch at:
git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git

Boris - have you had a chance to research how to fill in the AMD TBD section
yet?  Or should I just ask Ingo to pull this into tip now to be fixed later?

-Tony
