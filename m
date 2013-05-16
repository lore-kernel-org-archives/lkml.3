Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab3EPSgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 14:36:11 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:50528 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab3EPSgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 14:36:06 -0400
MIME-Version: 1.0
In-Reply-To: <20130516175350.GB7171@mtj.dyndns.org>
References: <1368498506-25857-1-git-send-email-yinghai@kernel.org>
	<1368498506-25857-7-git-send-email-yinghai@kernel.org>
	<0EE9A1CDC8D6434DB00095CD7DB873462CFB0E4E@MTLDAG01.mtl.com>
	<CAE9FiQVn4F+dTrQn0xsg-6QY9+HwbnJR=1CrjdoZkmF_LMrgpg@mail.gmail.com>
	<CAJZOPZLjdALP4jkLo6p787jaPx=dkKj7+AmCr9+mgJN3z_xBxQ@mail.gmail.com>
	<CAE9FiQWvYQRCZjDx-Kh16nKfjfS=pyu8foJR+wWYS-x8DUZteg@mail.gmail.com>
	<CAJZOPZLVc=V-ac8_A2JB_r17TRyCMoDpe1MXN6WcjMR4SO6n1Q@mail.gmail.com>
	<20130516175350.GB7171@mtj.dyndns.org>
Date: Thu, 16 May 2013 11:36:05 -0700
X-Google-Sender-Auth: AaUD8eeYzxBNJrLqFTh6bZFop4E
Message-ID: <CAE9FiQWPNt42gsRwYqQwJM6VpZ-UF2+r-64p_aS3X7GdeVbXCA@mail.gmail.com>
Subject: Re: [PATCH 6/7] PCI: Make sure VF's driver get attached after PF's
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Or Gerlitz <or.gerlitz@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Yan Burman <yanb@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jack Morgenstein <jackm@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yevgeny Petrilin <yevgenyp@mellanox.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 10:53 AM, Tejun Heo <tj@kernel.org> wrote:
> On Thu, May 16, 2013 at 12:56:42AM -0400, Or Gerlitz wrote:
>> > > Please note that this whole lockdep warning was identified as false
>> > > positive by Tejun http://www.spinics.net/lists/linux-pci/msg21568.html
>> >
>> > No, at least one time, I noticed there is one real hang happens.
>>
>> Tejun, so what your thinking here?
>
> Can't really tell much without more details.  Yinghai, do you have any
> logs from such hang?  Are you sure it's from this?

I did not keep that log.

Will remove AlexD patch, try several times to see if I can duplicate it again.

Thanks

Yinghai
