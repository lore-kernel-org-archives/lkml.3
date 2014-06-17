Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482AbaFQTTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:19:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933231AbaFQTS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:18:59 -0400
Date: Tue, 17 Jun 2014 12:22:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Christoph Lameter <cl@gentwo.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 02/24] sample/kobject: update kset-example code
Message-ID: <20140617192256.GE4319@kroah.com>
References: <53A05027.5020407@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A05027.5020407@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 10:26:47PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> Subject: sample/kobject: update kset-example code
> 
> Check and return the error ptr if call kset_create_and_add() failed
> 
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  samples/kobject/kset-example.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Nope, not taking this, sorry.

greg k-h
