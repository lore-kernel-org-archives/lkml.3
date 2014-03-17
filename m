Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaCQWvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 18:51:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaCQWvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 18:51:09 -0400
Date: Mon, 17 Mar 2014 15:53:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: Re: [char-misc-next 3/3 V2] mei: report consistently
 copy_from/to_user failures
Message-ID: <20140317225310.GA28519@kroah.com>
References: <1394623153-27046-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394623153-27046-1-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 01:19:13PM +0200, Tomas Winkler wrote:
> From: Alexander Usyskin <alexander.usyskin@intel.com>
> 
> Consistently display error on possible copy_from/to_user failures
> use dev_dbg  so it cannot be abused to flood the kernel log
> 
> Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Reviewed-on: https://git-isdc.jer.intel.com/gerrit/1158

That's a non-public URL, so it doesn't make sense to be put into a
kernel changelog :(

