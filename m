Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933707AbaFQTVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:21:33 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:51988 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933422AbaFQTVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:21:31 -0400
X-Sasl-enc: g+kN2iNPmLg56O7tS36IjN7yD/PY/sqRXYfCdzQ4eQoG 1403032890
Date: Tue, 17 Jun 2014 12:25:26 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/24] kernel: return actual error on param_sysfs_init
Message-ID: <20140617192526.GF4628@kroah.com>
References: <53A050B3.6050301@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A050B3.6050301@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 10:29:07PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Return the actual error code if kset_create_and_add() failed
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  kernel/params.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)

Andrew and Christoph, please do not take this patch.

thanks,

greg k-h
