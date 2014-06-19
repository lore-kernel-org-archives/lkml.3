Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966364AbaFSXdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 19:33:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52844 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965786AbaFSXdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 19:33:31 -0400
Date: Thu, 19 Jun 2014 16:37:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Martin Kepplinger <martink@posteo.de>
Cc: dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        forest@alittletooquiet.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] staging: vt6655: preserve address space in
 ethtool_ioctl()
Message-ID: <20140619233731.GA29983@kroah.com>
References: <1403008355-4163-1-git-send-email-martink@posteo.de>
 <1403008827-6098-1-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403008827-6098-1-git-send-email-martink@posteo.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 02:40:27PM +0200, Martin Kepplinger wrote:
> Fix the sparse error: cast removes address space of expression and
> add __user annotation to the driver's ethtool_ioctl().
> 
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> ---
> I think I forgot to change the declaration on top.

Someone else did this change just before you did, sorry :(

