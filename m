Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab3GVWIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 18:08:48 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40306 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751339Ab3GVWIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 18:08:47 -0400
Message-ID: <1374530925.2061.71.camel@joe-AO722>
Subject: Re: [PATCH 00/12] cdrom: neatening
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 22 Jul 2013 15:08:45 -0700
In-Reply-To: <cover.1372640818.git.joe@perches.com>
References: <cover.1372640818.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-06-30 at 18:11 -0700, Joe Perches wrote:
> Joe Perches (12):
>   cdrom: convert cdinfo to cd_dbg
>   cdrom: Remove unused CHECKAUDIO macro
>   cdrom: Remove obfuscating IOCTL_IN and IOCTL_OUT macros
>   cdrom: Remove prototype for open_for_data
>   cdrom: Remove unnecessary check_for_audio_disc prototype
>   cdrom: Remove unnecessary sanitize_format prototype
>   cdrom: Move mmc_ioctls above cdrom_ioctl to remove unnecessary prototype
>   cdrom: Remove cdrom_get_last_written prototype
>   cdrom: Remove cdrom_get_next_writeable prototype
>   cdrom: Remove cdrom_count_tracks prototype
>   cdrom: Remove unnecessary prototype for cdrom_mrw_exit
>   cdrom: Remove unnecessary prototype for cdrom_get_disc_info
> 
>  drivers/cdrom/cdrom.c | 1359 +++++++++++++++++++++++++------------------------
>  1 file changed, 682 insertions(+), 677 deletions(-)

Hey Jens.

ping?

Anything going to happen via you with these patches?

