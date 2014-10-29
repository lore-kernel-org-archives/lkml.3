Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934247AbaJ2PnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:43:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934097AbaJ2PmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:42:13 -0400
Date: Wed, 29 Oct 2014 17:38:03 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jes.Sorensen@redhat.com,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCH] staging: rtl8723au pointer issue
Message-ID: <20141029093803.GA10589@kroah.com>
References: <1414339196-4139-1-git-send-email-paulmcquad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414339196-4139-1-git-send-email-paulmcquad@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2014 at 03:59:56PM +0000, Paul McQuade wrote:
> ERROR: "foo*bar" should be "foo *bar"
> 
> Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_cmd.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

The subject does not make sense :(
