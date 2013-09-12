Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab3ILXAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 19:00:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab3ILXAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 19:00:44 -0400
Date: Thu, 12 Sep 2013 16:00:43 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tom Gundersen <teg@jklm.no>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2][usbutils] drop dependency on usb.ids
Message-ID: <20130912230043.GA5021@kroah.com>
References: <1378298828-18560-1-git-send-email-teg@jklm.no>
 <1378298828-18560-2-git-send-email-teg@jklm.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378298828-18560-2-git-send-email-teg@jklm.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 02:47:08PM +0200, Tom Gundersen wrote:
> Also remove usb.ids from the repository. [Note that these were probably
> never used by distributions regarless, as most distros ship the usb.ids
> directly from upstream.]
> 
> Hardcode the usb-spec information that used to be in usb.ids,
> but which was not moved to hwdb.
> 
> Increase the size of tha hash table from 16 to 512, though using a
> hash at all is probably overkill at this point.

Applied, thanks.

greg k-h
