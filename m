Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521AbaBKUcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:32:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504AbaBKUcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:32:33 -0500
Date: Tue, 11 Feb 2014 12:33:48 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: navin patidar <navin.patidar@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] staging: rtl8188eu: remove header file ethernet.h
Message-ID: <20140211203348.GA25883@kroah.com>
References: <1391935247-3797-1-git-send-email-navin.patidar@gmail.com>
 <1391935247-3797-3-git-send-email-navin.patidar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391935247-3797-3-git-send-email-navin.patidar@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 02:10:46PM +0530, navin patidar wrote:
> "ethernet.h" is included in three files but only "rtw_recv.c" using two macros
> defined in "ethernet.h", so move used macros in "rtw_recv.c" and
> remove "include/ethernet.h" header file and inclusion of this header file.
> 
> Signed-off-by: navin patidar <navin.patidar@gmail.com>
> ---
>  drivers/staging/rtl8188eu/core/rtw_recv.c      |    4 ++-
>  drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c |    1 -
>  drivers/staging/rtl8188eu/include/ethernet.h   |   42 ------------------------
>  drivers/staging/rtl8188eu/os_dep/recv_linux.c  |    1 -
>  4 files changed, 3 insertions(+), 45 deletions(-)
>  delete mode 100644 drivers/staging/rtl8188eu/include/ethernet.h

This patch fails to apply (2/3 had fuzz, but I fixed that up), can you
redo this against linux-next and resend it?

thanks,

greg k-h
