Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbaHGUqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 16:46:23 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.44.111]:41765 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaHGUqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 16:46:21 -0400
Message-ID: <53E3E53B.8060705@synopsys.com>
Date: Thu, 7 Aug 2014 13:44:43 -0700
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.cross-arch
To: Richard Weinberger <richard@nod.at>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
Subject: Re: [GIT PULL] Global signal cleanup
References: <53E20F1E.2080606@nod.at>
In-Reply-To: <53E20F1E.2080606@nod.at>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.21.21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Wednesday 06 August 2014 04:18 AM, Richard Weinberger wrote:
>       arc: Use get_signal() signal_setup_done()

I'd added this patch into arc tree for 3.17 (in linux-next for a while) and AFAIKR
I'd also left you a note to same effect. However it seems you are routing
everything thru ur tree, so I'll drop it from mine - OK ?

-Vineet
