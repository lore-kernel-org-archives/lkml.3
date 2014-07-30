Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbaG3N05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:26:57 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51110 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbaG3N04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:26:56 -0400
Date: Wed, 30 Jul 2014 16:26:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Anil Belur <askb23@gmail.com>
Cc: tklauser@distanz.ch, bjorn@mork.no, silvio.fricke@gmail.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] staging: vt6655: ioctl.c - missing __user annotation
Message-ID: <20140730132626.GI4856@mwanda>
References: <1406725197-18530-1-git-send-email-askb23@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406725197-18530-1-git-send-email-askb23@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 06:29:57PM +0530, Anil Belur wrote:
> - private_ioctl() internally calls copy_{to,from}_user() and does
>   not use '__user' which gives out several sparse warnings
> - these sparse warnings were fixed by adding __user annotation to
>   the data member of struct tagSCmdRequest:
> 
>  drivers/staging/vt6655/ioctl.c:78:51: warning: incorrect type in argument 2 (different address spaces)
>  drivers/staging/vt6655/ioctl.c:78:51:    expected void const [noderef] asn:1>*from
>  drivers/staging/vt6655/ioctl.c:78:51:    got void *data
> 
> Signed-off-by: Anil Belur <askb23@gmail.com>

Looks very nice now.

regards,
dan carpenter

