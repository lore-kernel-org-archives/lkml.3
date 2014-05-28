Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbaE1V3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:29:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41543 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbaE1V3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:29:20 -0400
Date: Wed, 28 May 2014 14:32:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaitanya Hazarey <c@24.io>
Cc: burzalodowa@gmail.com, andrea.merello@gmail.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: rtl8192u: r8192U_wx.c Added {} braces and
 newlines
Message-ID: <20140528213255.GA22186@kroah.com>
References: <1401287559-7692-1-git-send-email-c@24.io>
 <1401287559-7692-2-git-send-email-c@24.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401287559-7692-2-git-send-email-c@24.io>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 07:32:39AM -0700, Chaitanya Hazarey wrote:
> -static int r8192_wx_set_scan_type(struct net_device *dev, struct iw_request_info *aa, union
> -					iwreq_data *wrqu, char *p){
> +static int r8192_wx_set_scan_type(struct net_device *dev, struct iw_request_info *aa,
> +					union iwreq_data *wrqu, char *p){

The '{' still isn't in the right place, but I'll let you fix that up in
a future patch.

thanks,

greg k-h
