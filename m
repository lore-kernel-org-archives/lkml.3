Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934616AbaE2ODJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:03:09 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:49954 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932902AbaE2ODG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 10:03:06 -0400
Message-ID: <1401372183.25908.3.camel@x220>
Subject: Re: [PATCH v2 04/05] staging: board: Initial board staging support
From: Paul Bolle <pebolle@tiscali.nl>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        devel <devel@driverdev.osuosl.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Olof Johansson <olof@lixom.net>
Date: Thu, 29 May 2014 16:03:03 +0200
In-Reply-To: <CANqRtoQDQLsWOyRSbQmtbmJc_qO=5X3ZMK12ZuwZ-FSR1iWCog@mail.gmail.com>
References: <20140529131650.2329.3197.sendpatchset@w520>
	 <20140529131732.2329.50630.sendpatchset@w520>
	 <20140529132034.GB15585@mwanda>
	 <CANqRtoTzOn5d9qB85sXvmLYhoTDMDtbjSkLbz9V4FRmzFM3ycQ@mail.gmail.com>
	 <CANqRtoQDQLsWOyRSbQmtbmJc_qO=5X3ZMK12ZuwZ-FSR1iWCog@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 May 2014 14:03:04.0140 (UTC) FILETIME=[B594F8C0:01CF7B46]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-29 at 22:53 +0900, Magnus Damm wrote:
> --- 0011/drivers/staging/board/Kconfig
> +++ work/drivers/staging/board/Kconfig    2014-05-29 22:32:39.000000000 +0900
> @@ -1,5 +1,6 @@
>  config STAGING_BOARD
>      boolean "Staging Board Support"
> +    depends on OF && OF_ADDRESS

I have no idea what this is all about, but wouldn't just OF_ADDRESS be
enough here (as OF_ADDRESS depends on OF)?

>      help
>        Select to enable per-board staging support code.
> 
> Actually, there are not many dependencies - I believe the OF bits is about it.


Paul Bolle

