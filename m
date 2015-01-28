Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbbA1UMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:12:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42206 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbbA1UMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:12:21 -0500
Date: Wed, 28 Jan 2015 10:56:44 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: navin patidar <navin.patidar@gmail.com>, devel@driverdev.osuosl.org,
        Tapasweni Pathak <tapaswenipathak@gmail.com>,
        linux-kernel@vger.kernel.org, Jeff Oczek <jeffoczek@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH v3] staging: rtl8188eu: core: rtw_wlan_util: Remove some
 unused functions
Message-ID: <20150128185644.GA18395@kroah.com>
References: <1422207870-10616-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422207870-10616-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2015 at 06:44:30PM +0100, Rickard Strandqvist wrote:
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

Doesn't apply to my staging-testing branch at all :(
