Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbaFQTSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:18:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55395 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320AbaFQTSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:18:10 -0400
Date: Tue, 17 Jun 2014 12:22:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/24] drivers/of: return actual error on of_init
Message-ID: <20140617192206.GB4319@kroah.com>
References: <53A0510E.1010909@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A0510E.1010909@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 10:30:38PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Return the actual error code if call kset_create_and_add() failed
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  drivers/of/base.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Nope, not taking this, sorry.

