Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaAMRzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:55:25 -0500
Received: from void.printf.net ([89.145.121.20]:59890 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbaAMRzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:55:23 -0500
From: Chris Ball <chris@printf.net>
To: Dong Aisheng <dongas86@gmail.com>
Cc: David Cohen <david.a.cohen@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        gregkh <gregkh@linuxfoundation.org>,
        "linux-mmc\@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chuanxiao.dong" <chuanxiao.dong@intel.com>
Subject: Re: [RFC/PATCH 0/2] mmc: sdhci: Workaround Intel Merrifield issue for HS200
References: <1383069507-27574-1-git-send-email-david.a.cohen@linux.intel.com>
	<5282A255.5090904@linux.intel.com>
	<CAA+hA=SuhppL9Ejm1NSRrNmYZ_sE3Xnzf2gLSVYkFf7msEZNHw@mail.gmail.com>
	<20131220032516.GB19320@psi-dev26.jf.intel.com>
	<CAA+hA=SApxYn2=orNz8ZEF-uz7TQ8VBrbLcx6Ozzfd+zNuLCFQ@mail.gmail.com>
Date: Mon, 13 Jan 2014 17:55:17 +0000
In-Reply-To: <CAA+hA=SApxYn2=orNz8ZEF-uz7TQ8VBrbLcx6Ozzfd+zNuLCFQ@mail.gmail.com>
	(Dong Aisheng's message of "Fri, 20 Dec 2013 11:32:07 +0800")
Message-ID: <86bnzfdawq.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David, Dong,

On Fri, Dec 20 2013, Dong Aisheng wrote:
> On Fri, Dec 20, 2013 at 11:25 AM, David Cohen
> <david.a.cohen@linux.intel.com> wrote:
>> Merrifield still needs this quirk to not break MMC support.
>> This quirk could be applied to 3.13-rc (since merrifield was added to
>> sdhci-pci.c on 3.13-rc1).
>
> Okay, thanks for the information.
> So please take my ACK:
> Acked-by: Dong Aisheng <b29396@freescale.com>

Thanks, I've pushed this to mmc-next now.

- Chris.
-- 
Chris Ball   <chris@printf.net>   <http://printf.net/>
