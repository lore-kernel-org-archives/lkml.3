Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaKZUxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 15:53:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43099 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaKZUxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 15:53:33 -0500
Date: Wed, 26 Nov 2014 12:53:32 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Zahari Doychev <zahari.doychev@linux.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        oleg.drokin@intel.com, andreas.dilger@intel.com, bergwolf@gmail.com
Subject: Re: [PATCH 0/2] fix some sparse warnings in lustre
Message-ID: <20141126205332.GA10615@kroah.com>
References: <cover.1416853961.git.zahari.doychev@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1416853961.git.zahari.doychev@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 07:55:40PM +0100, Zahari Doychev wrote:
> The two patches fix several sparse warning in the lustre module.
> 
> Zahari Doychev (2):
>   [drivers] staging/lustre: fix sparse warnings
>   [drivers] staging/lustre: fix sparse warnings
> 
>  drivers/staging/lustre/include/linux/lnet/lib-lnet.h   | 14 +++++++++-----
>  drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c | 15 ++++++++++-----
>  2 files changed, 19 insertions(+), 10 deletions(-)

Please fix up and resend anything still pending, I've purged your
patches from my queue now as they all seem to not be correct :(
