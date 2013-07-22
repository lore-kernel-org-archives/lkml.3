Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab3GVQx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:53:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab3GVQx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:53:56 -0400
Date: Mon, 22 Jul 2013 09:53:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Kiko Piris <kernel@pirispons.net>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: 3.10.1 cpufreq suspend/resume regression still present in 3.10.2
Message-ID: <20130722165355.GA18371@kroah.com>
References: <20130722151653.GA7213@sacarino.pirispons.net>
 <51ED4E2D.5020908@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51ED4E2D.5020908@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 08:52:21PM +0530, Srivatsa S. Bhat wrote:
> And both of them have been CC'ed to -stable. So they should be hitting
> the stable tree soon.
> 
> Hmm, that reminds me.. whenever a patch cc'ed to stable hit the mainline,
> the patch signers used to receive an automatic email from Greg. I didn't
> get that for the above two patches.. Did the process change due to the
> recent discussions around -stable tree maintenance?

No, it did not change, I just have 150+ pending patches for the
3.11-stable tree that I have yet to get through, give me a few weeks
please.

thanks,

greg k-h
