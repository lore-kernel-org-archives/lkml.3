Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab3EPJt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 05:49:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:62123 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab3EPJtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 05:49:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,683,1363158000"; 
   d="scan'208";a="334999722"
Date: Thu, 16 May 2013 11:49:17 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Brown <davidb@codeaurora.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>, Richard Kuo <rkuo@codeaurora.org>,
        linux-hexagon@vger.kernel.org
Subject: Re: MFD: move ssbi driver into drivers/mfd
Message-ID: <20130516094917.GD22822@zurbaran>
References: <20130429162115.GA6893@kroah.com>
 <8yafvy92gfs.fsf@huya.qualcomm.com>
 <CA+55aFxaMP+=uMLLvnLHz_E0GStrDf_zO3XhVCDGHbk=tV6CqA@mail.gmail.com>
 <201304300000.19488.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201304300000.19488.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Tue, Apr 30, 2013 at 12:00:19AM +0200, Arnd Bergmann wrote:
> There is no reason for ssbi to have its own top-level driver directory
> when the only users of this interface are all MFD drivers. The only
> mainline driver using it at the moment (PM8921) is marked broken and in
> fact does not compile. I have verified that fixing the trivial build
> breakage in pm8921 links in the new ssbi code just fine, but that
> can be a separate patch.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  drivers/Kconfig              |  2 --
>  drivers/Makefile             |  1 -
>  drivers/mfd/Kconfig          |  3 ++-
>  drivers/mfd/Makefile         |  2 +-
>  drivers/{ssbi => mfd}/ssbi.c |  0
>  drivers/ssbi/Kconfig         | 16 ----------------
>  drivers/ssbi/Makefile        |  1 -
>  7 files changed, 3 insertions(+), 22 deletions(-)
Applied to my mfd-next tree, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
