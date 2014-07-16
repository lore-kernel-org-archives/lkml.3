Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbaGPKVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:21:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58877 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaGPKVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:21:13 -0400
Date: Wed, 16 Jul 2014 11:21:10 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "arc-linux-dev@synopsys.com" <arc-linux-dev@synopsys.com>
Subject: Re: ARC backport for stable 3.{10,12,14,15}
Message-ID: <20140716102110.GA20684@hercules>
References: <53C6007A.9050707@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53C6007A.9050707@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 10:02:58AM +0530, Vineet Gupta wrote:
> Hi,
> 
> Can you please add the mainline commit a4b6cb735b25aa84a462a1985e3e43bebaf5beb4
> "ARC: Implement ptrace(PTRACE_GET_THREAD_AREA)" to stable kernels
> 
> This is causing buildroot gdb failures with pre 3.16 kernels.
> 
> Thx,
> -Vineet
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thank you, I'll queue it for the 3.11 kernel.

Cheers,
--
Luís
