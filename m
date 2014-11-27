Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbaK0DFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 22:05:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46122 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847AbaK0DFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 22:05:45 -0500
Date: Wed, 26 Nov 2014 19:04:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 2/3] mei: export fw status registers through
 sysfs
Message-ID: <20141127030424.GA8656@kroah.com>
References: <1416409300-14431-1-git-send-email-tomas.winkler@intel.com>
 <1416409300-14431-2-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416409300-14431-2-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 05:01:39PM +0200, Tomas Winkler wrote:
> The interface is for applications that monitor
> the fw health.
> 
> We use device_create_with_groups interface
> to register attribute with the mei class device
> 
> Signed-off-by :Tomas Winkler <tomas.winkler@intel.com>
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

What happened here?
