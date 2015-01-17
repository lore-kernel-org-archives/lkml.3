Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbbAQWRE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 17:17:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbbAQWRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 17:17:03 -0500
Date: Sat, 17 Jan 2015 13:55:35 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <Jes.Sorensen@redhat.com>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: os_dep: usb_intf.c:  Remove some
 unused functions
Message-ID: <20150117215535.GA1711@kroah.com>
References: <1418848615-1745-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418848615-1745-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 09:36:54PM +0100, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> rtw_hw_resume23a() rtw_hw_suspend23a()
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  drivers/staging/rtl8723au/include/osdep_intf.h |    3 -
>  drivers/staging/rtl8723au/os_dep/usb_intf.c    |  100 ------------------------
>  2 files changed, 103 deletions(-)

No longer applies to my tree :(
