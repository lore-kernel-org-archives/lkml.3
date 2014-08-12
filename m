Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaHLGCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 02:02:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaHLGCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 02:02:33 -0400
Date: Tue, 12 Aug 2014 14:01:53 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Sanjeev Sharma <sanjeev_sharma@mentor.com>
Cc: hdegoede@redhat.com, kraxel@redhat.com, mdharm-usb@one-eyed-alien.net,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] uas: replace WARN_ON_ONCE() with lockdep_assert_held()
Message-ID: <20140812060153.GB13231@kroah.com>
References: <1407823717-17265-1-git-send-email-sanjeev_sharma@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407823717-17265-1-git-send-email-sanjeev_sharma@mentor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 11:38:37AM +0530, Sanjeev Sharma wrote:
> spin_is_locked() always return false in uniprocessor configuration and therefore it
> would be advise to replace with lockdep_assert_held().

Add "on some architectures" in here somewhere, as it's not broken on the
large majority of UP cpus :)

thanks,

greg k-h
