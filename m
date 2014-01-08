Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbaAHX0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 18:26:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932337AbaAHX0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 18:26:48 -0500
Date: Wed, 8 Jan 2014 15:27:18 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: Re: [char-misc 4/4] mei: limit the number of consecutive resets
Message-ID: <20140108232718.GA21441@kroah.com>
References: <1389205164-13553-1-git-send-email-tomas.winkler@intel.com>
 <1389205164-13553-5-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389205164-13553-5-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 08:19:24PM +0200, Tomas Winkler wrote:
> give up reseting after 3 unsuccessful tries
> 
> Cc: <stable@vger.kernel.org> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
> ---
>  drivers/misc/mei/client.c  |  1 +
>  drivers/misc/mei/init.c    | 10 ++++++++++
>  drivers/misc/mei/mei_dev.h |  7 +++++++
>  3 files changed, 18 insertions(+)

Doesn't apply as patch 3/4 didn't apply.

Which means it shouldn't be for a stable kernel either...

greg k-h
