Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab3GYHwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 03:52:11 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:53314 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab3GYHwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 03:52:08 -0400
Message-ID: <1374738723.8827.3.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 33/36] net: rfkill: convert class code to use dev_groups
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Thu, 25 Jul 2013 09:52:03 +0200
In-Reply-To: <1374703539-9705-34-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
	 <1374703539-9705-34-git-send-email-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-24 at 15:05 -0700, Greg Kroah-Hartman wrote:
> The dev_attrs field of struct class is going away soon, dev_groups
> should be used instead.  This converts the rfkill class code to use the
> correct field.
> 
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> 
> Johnannes, feel free to take this through your tree, or ACK it and I can
> take it through mine.

Looks good to me, go ahead and take it, we're not going to modify this
code.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

