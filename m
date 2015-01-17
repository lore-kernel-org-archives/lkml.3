Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbbAQW3l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 17:29:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbbAQW3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 17:29:40 -0500
Date: Sat, 17 Jan 2015 14:13:22 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: navin patidar <navin.patidar@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jeff Oczek <jeffoczek@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8188eu: core: rtw_wlan_util.c:  Remove some
 unused functions
Message-ID: <20150117221322.GA6453@kroah.com>
References: <1419092651-7400-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419092651-7400-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2014 at 05:24:11PM +0100, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> CAM_empty_entry() get_bsstype() rtw_get_oper_choffset()
> rtw_get_oper_bw() is_ap_in_wep() should_forbid_n_rate()
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/rtl8188eu/core/rtw_wlan_util.c   |   90 ----------------------
>  drivers/staging/rtl8188eu/include/rtw_mlme_ext.h |    6 --
>  2 files changed, 96 deletions(-)

Doesn't apply :(
