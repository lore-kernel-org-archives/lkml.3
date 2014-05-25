Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401AbaEYWMi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 18:12:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaEYWMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 18:12:37 -0400
Date: Sun, 25 May 2014 15:12:35 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@laposte.net>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [PATCH linux-next] imx-drm: imx-tve: remove unused variable
Message-ID: <20140525221235.GA26619@kroah.com>
References: <1401054854-20932-1-git-send-email-vincent.stehle@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401054854-20932-1-git-send-email-vincent.stehle@laposte.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2014 at 11:54:14PM +0200, Vincent Stehlé wrote:
> Commit f9b0e251dfbf 'drm: make mode_valid callback optional' left variable ret
> unused; remove it.
> 
> This fixes the following compilation warning:
> 
>   drivers/staging/imx-drm/imx-tve.c: In function ‘imx_tve_connector_mode_valid’:
>   drivers/staging/imx-drm/imx-tve.c:252:6: warning: unused variable ‘ret’ [-Wunused-variable]

It doesn't apply to my tree :(
