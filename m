Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbaFDFsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 01:48:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbaFDFsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 01:48:52 -0400
Date: Tue, 3 Jun 2014 22:48:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        xen-devel@lists.xenproject.org, felipe.franciosi@citrix.com,
        roger.pau@citrix.com, jerry.snitselaar@oracle.com, axboe@kernel.dk
Subject: Re: Backport request to stable of two performance related fixes for
 xen-blkfront (3.13 fixes to earlier trees)
Message-ID: <20140604054848.GA20895@kroah.com>
References: <20140514191122.GA7659@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514191122.GA7659@phenom.dumpdata.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 03:11:22PM -0400, Konrad Rzeszutek Wilk wrote:
> Hey Greg
> 
> This email is in regards to backporting two patches to stable that
> fall under the 'performance' rule:
> 
>  bfe11d6de1c416cea4f3f0f35f864162063ce3fa
>  fbe363c476afe8ec992d3baf682670a4bd1b6ce6

Now queued up, thanks.

greg k-h
