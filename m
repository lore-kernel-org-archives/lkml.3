Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbaK0DJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 22:09:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaK0DJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 22:09:01 -0500
Date: Wed, 26 Nov 2014 19:07:40 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next] mei: bus: use ssize_t as the return type for
 send and receive
Message-ID: <20141127030740.GA27141@kroah.com>
References: <1416815466-22419-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416815466-22419-1-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 09:51:06AM +0200, Tomas Winkler wrote:
> Mei bus receive and send function may return either number
> of transmitted bytes or errno.  It is better to use ssize_t
> type for that purpose that mixing size_t with int.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/misc/mei/bus.c     | 30 ++++++++++++++----------------
>  drivers/misc/mei/mei_dev.h |  6 +++---
>  include/linux/mei_cl_bus.h |  4 ++--
>  3 files changed, 19 insertions(+), 21 deletions(-)

Doesn't apply :(
