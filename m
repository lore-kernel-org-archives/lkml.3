Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab3L0CMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 21:12:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab3L0CMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 21:12:45 -0500
Date: Thu, 26 Dec 2013 18:13:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: rob@landley.net, Andrew Morton <akpm@linux-foundation.org>,
        vegardno@ifi.uio.no, Pekka Enberg <penberg@kernel.org>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] doc/kmemcheck: add kmemcheck to kernel-parameters.txt
Message-ID: <20131227021314.GA25685@kroah.com>
References: <52BBA18F.4080102@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52BBA18F.4080102@huawei.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 26, 2013 at 11:25:03AM +0800, Xishi Qiu wrote:
> Add kmemcheck to Documentation/kernel-parameters.txt.
> 
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> ---
>  Documentation/kernel-parameters.txt |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
