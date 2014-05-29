Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbaE2Ujm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 16:39:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbaE2Ujl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 16:39:41 -0400
Date: Thu, 29 May 2014 13:43:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaitanya Hazarey <c@24.io>
Cc: burzalodowa@gmail.com, andrea.merello@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Staging: rtl8192u: r8192U_wx.c Fixed a misplaced
 brace
Message-ID: <20140529204317.GA9865@kroah.com>
References: <1401319428-20798-1-git-send-email-c@24.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401319428-20798-1-git-send-email-c@24.io>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 04:23:47PM -0700, Chaitanya Hazarey wrote:
> Fixed a misplaced brace in a function
> 
> Signed-off-by: Chaitanya Hazarey <c@24.io>
> ---
>  drivers/staging/rtl8192u/r8192U_wx.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Where is patch 2/2 ?

