Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbbAQWUU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 17:20:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55248 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbbAQWUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 17:20:18 -0500
Date: Sat, 17 Jan 2015 13:58:39 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <Jes.Sorensen@redhat.com>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: hal: rtl8723au_led.c:  Remove some
 unused functions
Message-ID: <20150117215839.GA18538@kroah.com>
References: <1419166779-2619-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419166779-2619-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 01:59:39PM +0100, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> rtl8723au_DeInitSwLeds() rtl8723au_InitSwLeds()
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/rtl8723au/hal/rtl8723au_led.c    |   23 ----------------------
>  drivers/staging/rtl8723au/include/rtl8723a_led.h |    2 --
>  2 files changed, 25 deletions(-)

These files aren't even in the tree anymore :(
