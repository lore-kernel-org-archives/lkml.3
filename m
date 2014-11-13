Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676AbaKMPOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:14:23 -0500
Received: from smtp3.tech.numericable.fr ([82.216.111.39]:44548 "EHLO
	smtp3.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933418AbaKMPOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:14:21 -0500
Message-ID: <5464CAAF.7050907@laposte.net>
Date: Thu, 13 Nov 2014 16:13:51 +0100
From: Barto <mister.freeman@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Joe Perches <joe@perches.com>
Subject: Re: BUG in scsi_lib.c due to a bad commit
References: <54629CAE.2000207@laposte.net> <CAErSpo6FFK6zMOWSK9=dOOMKjWd1soAyj9r73yP8Z_U4F9ygAA@mail.gmail.com> <5462CB90.1080303@roeck-us.net> <54642541.9080302@laposte.net> <94D0CD8314A33A4D9D801C0FE68B4029593A1880@G9W0745.americas.hpqcorp.net> <54647C10.4070506@laposte.net> <20141113142907.GB29354@infradead.org>
In-Reply-To: <20141113142907.GB29354@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrjedugddtvdcutefuodetggdotefrucfrrhhofhhilhgvmecupfgfoffgtffkveetuefngfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffhfgfggfvufhfjggtgfesthekrgdttdefheenucfhrhhomhepuegrrhhtohcuoehmihhsthgvrhdrfhhrvggvmhgrnheslhgrphhoshhtvgdrnhgvtheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrgh
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not sure to understand your request, it's quite confusing,

you ask me to revert this commit and see if the bug is gone ? :

74665016086615bbaa3fa6f83af410a0a4e029ee scsi: convert host_busy to atomic_t

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=74665016086615bbaa3fa6f83af410a0a4e029ee

Le 13/11/2014 15:29, Christoph Hellwig a écrit :
> Guenters commit just fixes the inversion from commit
> 
> 71e75c97f97a9645d25fbf3d8e4165a558f18747 scsi: convert device_busy to atomic_t
> 
> Can you please test the commit before that:
> 74665016086615bbaa3fa6f83af410a0a4e029ee scsi: convert host_busy to atomic_t
> 
> and check if that works for you or not.
> 
