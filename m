Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbaJHWkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 18:40:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaJHWkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 18:40:10 -0400
Date: Wed, 8 Oct 2014 15:40:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Karthik Nayak <karthik.188@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        gamerh2o@gmail.com, mark.einon@gmail.com
Subject: Re: [PATCH] staging: bcm: multiple checkpatch fixes for
 InterfaceIdleMode.c
Message-ID: <20141008224009.GA9464@kroah.com>
References: <1412097977-3254-1-git-send-email-karthik.188@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412097977-3254-1-git-send-email-karthik.188@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 10:56:17PM +0530, Karthik Nayak wrote:
> 1. WARNING: else is not generally useful after a break or return
> 
> 2. WARNING: quoted string split across lines
> 
> 3. WARNING: break quoted strings at a space character
> 
> Signed-off-by: Karthik Nayak <karthik.188@gmail.com>
> ---
>  drivers/staging/bcm/InterfaceIdleMode.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)

Doesn't apply to my tree :(
