Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261Ab3D3AAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 20:00:15 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60519 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932591Ab3D3AAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 20:00:13 -0400
X-IronPort-AV: E=Sophos;i="4.87,576,1363158000"; 
   d="scan'208";a="42740305"
From: David Brown <davidb@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>, Richard Kuo <rkuo@codeaurora.org>,
        linux-hexagon@vger.kernel.org
Subject: Re: MFD: move ssbi driver into drivers/mfd
References: <20130429162115.GA6893@kroah.com>
	<8yafvy92gfs.fsf@huya.qualcomm.com>
	<CA+55aFxaMP+=uMLLvnLHz_E0GStrDf_zO3XhVCDGHbk=tV6CqA@mail.gmail.com>
	<201304300000.19488.arnd@arndb.de>
Date: Mon, 29 Apr 2013 17:00:12 -0700
In-Reply-To: <201304300000.19488.arnd@arndb.de> (Arnd Bergmann's message of
	"Tue, 30 Apr 2013 00:00:19 +0200")
Message-ID: <8yay5c028hf.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> There is no reason for ssbi to have its own top-level driver directory
> when the only users of this interface are all MFD drivers. The only
> mainline driver using it at the moment (PM8921) is marked broken and in
> fact does not compile. I have verified that fixing the trivial build
> breakage in pm8921 links in the new ssbi code just fine, but that
> can be a separate patch.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Samuel Ortiz <sameo@linux.intel.com>

Acked-by: David Brown <davidb@codeaurora.org>

Coming soon, I hope, are going to be the DT conversion of the 8921
driver, and possibly drivers for a few of the other pmic chips.

And, thanks for moving this.

David

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
