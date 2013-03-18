Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751271Ab3CRB66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 21:58:58 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:39287 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab3CRB6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 21:58:55 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r2I1wlSP030137, This message is released by code: ctlocs8528
Message-ID: <514674D6.3090804@realsil.com.cn>
Date: Mon, 18 Mar 2013 09:58:46 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: mmc: rts_pstor worked fine, but rtsx_pci_sdmmc does not
References: <20130316125411.GB3753@netboy.at.omicron.at>
In-Reply-To: <20130316125411.GB3753@netboy.at.omicron.at>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.29.41.8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard:

Could you please describe the detailed model of your 4G card? It would 
be better if you can take a picture of that card or give me the Amazon 
link of it. It looks like a compatibility issue.

BR,
Wei

于 2013年03月16日 20:54, Richard Cochran 写道:
> I have an Acer Aspire One netbook with a built in card reader, and I
> have two cards, one with 32 MB and one with 4 GB. The card reader used
> to work with the staging driver in 3.7.10, but the new 3.8.3 driver
> does not work with the larger card. The old driver was removed in
> commit cd211222.
>
> Now, when inserting the larger card, the kernel just prints an error,
> as shown below. Anyone know how to fix this?
>
> Thanks,
> Richard
>
> ** With new 3.8.3 driver
> *** 32 MB card
> Mar 16 11:29:45 netboy kernel: [  149.431780] mmc0: new MMC card at address 0001
> Mar 16 11:29:45 netboy kernel: [  149.519891] mmcblk0: mmc0:0001 32M    30.6 MiB
> Mar 16 11:29:45 netboy kernel: [  149.524102]  mmcblk0: p1
> Mar 16 11:30:20 netboy kernel: [  184.195164] mmc0: card 0001 removed
>
> *** 4G MB card
> Mar 16 11:31:13 netboy kernel: [  237.267134] mmc0: error -110 whilst initialising SD card
> Mar 16 11:31:14 netboy kernel: [  238.497137] mmc0: error -110 whilst initialising SD card
> Mar 16 11:31:15 netboy kernel: [  239.727136] mmc0: error -110 whilst initialising SD card
>
> ** With old 3.7.10 staging driver
> *** 32 MB card
> Mar 16 13:11:01 netboy kernel: [  129.222352] sd 4:0:0:0: [sdb] 62720 512-byte logical blocks: (32.1 MB/30.6 MiB)
> Mar 16 13:11:01 netboy kernel: [  129.222559] sd 4:0:0:0: [sdb] Cache data unavailable
> Mar 16 13:11:01 netboy kernel: [  129.222572] sd 4:0:0:0: [sdb] Assuming drive cache: write through
> Mar 16 13:11:01 netboy kernel: [  129.222985] sd 4:0:0:0: [sdb] Cache data unavailable
> Mar 16 13:11:01 netboy kernel: [  129.223002] sd 4:0:0:0: [sdb] Assuming drive cache: write through
> Mar 16 13:11:01 netboy kernel: [  129.226132]  sdb: sdb1
> Mar 16 13:11:09 netboy kernel: [  136.909833] sdb: detected capacity change from 32112640 to 0
>
> *** 4 GB card
> Mar 16 13:12:45 netboy kernel: [  232.909525] sd 4:0:0:0: [sdb] 7626752 512-byte logical blocks: (3.90 GB/3.63 GiB)
> Mar 16 13:12:45 netboy kernel: [  232.909769] sd 4:0:0:0: [sdb] Cache data unavailable
> Mar 16 13:12:45 netboy kernel: [  232.909786] sd 4:0:0:0: [sdb] Assuming drive cache: write through
> Mar 16 13:12:45 netboy kernel: [  232.910593] sd 4:0:0:0: [sdb] Cache data unavailable
> Mar 16 13:12:45 netboy kernel: [  232.910612] sd 4:0:0:0: [sdb] Assuming drive cache: write through
> Mar 16 13:12:45 netboy kernel: [  232.912631]  sdb: sdb1 sdb2
> Mar 16 13:12:59 netboy kernel: [  246.909480] sdb: detected capacity change from 3904897024 to 0
>
>
>
>
> .
>

