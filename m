Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbbAYQW0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 11:22:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbbAYQPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 11:15:35 -0500
Date: Sun, 25 Jan 2015 19:49:56 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: navin patidar <navin.patidar@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jeff Oczek <jeffoczek@gmail.com>,
        Tapasweni Pathak <tapaswenipathak@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: rtl8188eu: core: rtw_wlan_util: Remove
 unused functions
Message-ID: <20150125114956.GA5247@kroah.com>
References: <1421544090-18374-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421544090-18374-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 02:21:29AM +0100, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> CAM_empty_entry() get_bsstype() rtw_get_oper_choffset()
> rtw_get_oper_bw() is_ap_in_wep() should_forbid_n_rate()
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/rtl8188eu/core/rtw_wlan_util.c   |  136 ----------------------
>  drivers/staging/rtl8188eu/include/rtw_mlme_ext.h |    6 -
>  2 files changed, 142 deletions(-)

This patch doesn't apply to my staging-next branch of staging.git at all
:(
