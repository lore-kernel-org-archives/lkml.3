Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab3KHQN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 11:13:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024Ab3KHQN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 11:13:57 -0500
Message-ID: <527D0D8F.5010001@redhat.com>
Date: Fri, 08 Nov 2013 11:13:03 -0500
From: Doug Ledford <dledford@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
CC: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] delete decade+ obsolete aic7xxx_old driver
References: <20131108160446.GA16190@windriver.com>
In-Reply-To: <20131108160446.GA16190@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 11:04 AM, Paul Gortmaker wrote:

> Paul Gortmaker (1):
>        scsi: delete decade+ obsolete aic7xxx_old driver
>
>   Documentation/scsi/00-INDEX             |     2 -
>   Documentation/scsi/aic7xxx_old.txt      |   511 --
>   MAINTAINERS                             |     1 -
>   drivers/scsi/Kconfig                    |    41 -
>   drivers/scsi/Makefile                   |     1 -
>   drivers/scsi/aic7xxx_old.c              | 11149 ------------------------------
>   drivers/scsi/aic7xxx_old/aic7xxx.h      |    28 -
>   drivers/scsi/aic7xxx_old/aic7xxx.reg    |  1401 ----
>   drivers/scsi/aic7xxx_old/aic7xxx.seq    |  1539 -----
>   drivers/scsi/aic7xxx_old/aic7xxx_proc.c |   270 -
>   drivers/scsi/aic7xxx_old/aic7xxx_reg.h  |   629 --
>   drivers/scsi/aic7xxx_old/aic7xxx_seq.c  |   817 ---
>   drivers/scsi/aic7xxx_old/scsi_message.h |    49 -
>   drivers/scsi/aic7xxx_old/sequencer.h    |   135 -
>   14 files changed, 16573 deletions(-)
>   delete mode 100644 Documentation/scsi/aic7xxx_old.txt
>   delete mode 100644 drivers/scsi/aic7xxx_old.c
>   delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx.h
>   delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx.reg
>   delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx.seq
>   delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx_proc.c
>   delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx_reg.h
>   delete mode 100644 drivers/scsi/aic7xxx_old/aic7xxx_seq.c
>   delete mode 100644 drivers/scsi/aic7xxx_old/scsi_message.h
>   delete mode 100644 drivers/scsi/aic7xxx_old/sequencer.h
>

Farewell old friend...don't let the door hit you in the ass on the way 
out ;-)
