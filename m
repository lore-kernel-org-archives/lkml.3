Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab3G1Nbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 09:31:31 -0400
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:35607 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753078Ab3G1Nba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 09:31:30 -0400
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Jul 2013 09:31:30 EDT
Date: Sun, 28 Jul 2013 15:23:25 +0200
From: Alessandro Zummo <a.zummo@towertech.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/36] rtc: convert class code to use dev_groups
Message-ID: <20130728152325.7abe51f1@linux.lan.towertech.it>
In-Reply-To: <1374703539-9705-20-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
	<1374703539-9705-20-git-send-email-gregkh@linuxfoundation.org>
Organization: Tower Technologies
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jul 2013 15:05:22 -0700
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> The dev_attrs field of struct class is going away soon, dev_groups
> should be used instead.  This converts the rtc class code to use the
> correct field.
> 
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> 
> Alessandro, feel free to take this through your tree, or ACK it and I
> can take it through mine.

 I'd appreciate if you can carry it.

 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

