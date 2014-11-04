Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbaKDQc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:32:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45206 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaKDQc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:32:58 -0500
Date: Tue, 4 Nov 2014 08:31:48 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: Re: [char-misc V3 3.18] mei: nfc: clean nfc internal struct on host
 exit
Message-ID: <20141104163148.GB14034@kroah.com>
References: <1415110489-25270-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415110489-25270-1-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 04:14:49PM +0200, Tomas Winkler wrote:
> NFC internal structure cleaning was dropped by commit
> 
> commit 5ad1550a15cd5b75ed8aa3009e162822f720375e
> Author: Tomas Winkler <tomas.winkler@intel.com>
> Date:   Sun Jan 26 11:53:06 2014 +0200

Where is this commit id from?  I don't see it in Linus's tree.

thanks,

greg k-h
