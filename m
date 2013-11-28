Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab3K1NNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 08:13:15 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18268 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab3K1NNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 08:13:13 -0500
To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Cc: "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        "'open list'" <linux-kernel@vger.kernel.org>,
        <linux-ext4@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Subject: Re: 3.12.0: sda2: WRITE SAME failed. Manually zeroing. with 3w-xxxx driver
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <00c701ceec3a$c8bcfc90$5a36f5b0$@lucidpixels.com> (Justin
	Piszcz's message of "Thu, 28 Nov 2013 08:07:24 -0500")
Organization: Oracle Corporation
References: <CAO9zADw-k+Qghk79yzwzaiYiPSoQnKwjjTBwrhcOrJxTWc-fOQ@mail.gmail.com>
	<yq1iovclm0m.fsf@sermon.lab.mkp.net>
	<00c701ceec3a$c8bcfc90$5a36f5b0$@lucidpixels.com>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
Date: Thu, 28 Nov 2013 08:13:07 -0500
Message-ID: <yq1d2lkllek.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Justin" == Justin Piszcz <jpiszcz@lucidpixels.com> writes:

Martin> I posted a patch a while back that prevents WRITE SAME being
Martin> issued for controllers that do not pass the commands through to
Martin> disk directly:

Martin>	http://marc.info/?l=linux-scsi&m=138252394614920&w=2

Justin> Awesome, thank you!  This patch is over a month old, do you know
Justin> if is currently in mainline? 

Nope. - James?

-- 
Martin K. Petersen	Oracle Linux Engineering
