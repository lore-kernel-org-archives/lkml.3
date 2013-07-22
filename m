Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab3GVWJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 18:09:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54287 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3GVWJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 18:09:13 -0400
Message-ID: <51EDAD79.3050707@kernel.dk>
Date: Mon, 22 Jul 2013 16:08:57 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] cdrom: neatening
References: <cover.1372640818.git.joe@perches.com> <1374530925.2061.71.camel@joe-AO722>
In-Reply-To: <1374530925.2061.71.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 04:08 PM, Joe Perches wrote:
> On Sun, 2013-06-30 at 18:11 -0700, Joe Perches wrote:
>> Joe Perches (12):
>>   cdrom: convert cdinfo to cd_dbg
>>   cdrom: Remove unused CHECKAUDIO macro
>>   cdrom: Remove obfuscating IOCTL_IN and IOCTL_OUT macros
>>   cdrom: Remove prototype for open_for_data
>>   cdrom: Remove unnecessary check_for_audio_disc prototype
>>   cdrom: Remove unnecessary sanitize_format prototype
>>   cdrom: Move mmc_ioctls above cdrom_ioctl to remove unnecessary prototype
>>   cdrom: Remove cdrom_get_last_written prototype
>>   cdrom: Remove cdrom_get_next_writeable prototype
>>   cdrom: Remove cdrom_count_tracks prototype
>>   cdrom: Remove unnecessary prototype for cdrom_mrw_exit
>>   cdrom: Remove unnecessary prototype for cdrom_get_disc_info
>>
>>  drivers/cdrom/cdrom.c | 1359 +++++++++++++++++++++++++------------------------
>>  1 file changed, 682 insertions(+), 677 deletions(-)
> 
> Hey Jens.
> 
> ping?
> 
> Anything going to happen via you with these patches?

I'll queue them up for 3.12.

-- 
Jens Axboe

