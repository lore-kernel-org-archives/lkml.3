Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbaEEVCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 17:02:15 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:37049 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbaEEVCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 17:02:14 -0400
Message-ID: <5367FC59.6060201@kernel.dk>
Date: Mon, 05 May 2014 15:02:17 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] cdrom: neatening
References: <51EDAD79.3050707@kernel.dk> <cover.1399247745.git.joe@perches.com>
In-Reply-To: <cover.1399247745.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2014 06:05 PM, Joe Perches wrote:
> Hey Jens.
> 
> I was cleaning up a bunch of old stuff on my computer
> and noticed these...
> 
> On Mon, 2013-07-22 at 16:08 -0600, Jens Axboe wrote:
>> On 07/22/2013 04:08 PM, Joe Perches wrote:
>>> Anything going to happen via you with these patches?
>> I'll queue them up for 3.12.
> 
> Awhile ago these might have been queued up somewhere,
> but as far as I can tell, never got applied.
> 
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
>  drivers/cdrom/cdrom.c | 1357 +++++++++++++++++++++++++------------------------
>  1 file changed, 681 insertions(+), 676 deletions(-)

Applied for 3.16, thanks.


-- 
Jens Axboe

