Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751043AbaKCX4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 18:56:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaKCX4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 18:56:31 -0500
Date: Mon, 3 Nov 2014 15:56:30 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: Re: [char-misc-next V2] mei: nfc: clean nfc internal struct on host
 exit
Message-ID: <20141103235630.GA31313@kroah.com>
References: <1412667290-27964-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412667290-27964-1-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 10:34:50AM +0300, Tomas Winkler wrote:
> NFC internal structure cleaning was dropped by commit
> 
> commit 5ad1550a15cd5b75ed8aa3009e162822f720375e
> Author: Tomas Winkler <tomas.winkler@intel.com>
> Date:   Sun Jan 26 11:53:06 2014 +0200
> 
>     mei: Remove all bus devices from the mei_dev list when stopping the MEI
> 
> We allocate nfc_dev and free it across the reset
> so we do not keep it in dirty state
> 
> Stable: 3.15+

Please read Documentation/stable_kernel_rules.txt for how to do this
properly.

Please resend, after really verifying this does need to go to the stable
trees...

thanks,

greg k-h
