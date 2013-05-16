Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab3EPRx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 13:53:59 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:33495 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab3EPRx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 13:53:57 -0400
Date: Thu, 16 May 2013 10:53:50 -0700
From: Tejun Heo <tj@kernel.org>
To: Or Gerlitz <or.gerlitz@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        Yan Burman <yanb@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jack Morgenstein <jackm@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yevgeny Petrilin <yevgenyp@mellanox.com>
Subject: Re: [PATCH 6/7] PCI: Make sure VF's driver get attached after PF's
Message-ID: <20130516175350.GB7171@mtj.dyndns.org>
References: <1368498506-25857-1-git-send-email-yinghai@kernel.org>
 <1368498506-25857-7-git-send-email-yinghai@kernel.org>
 <0EE9A1CDC8D6434DB00095CD7DB873462CFB0E4E@MTLDAG01.mtl.com>
 <CAE9FiQVn4F+dTrQn0xsg-6QY9+HwbnJR=1CrjdoZkmF_LMrgpg@mail.gmail.com>
 <CAJZOPZLjdALP4jkLo6p787jaPx=dkKj7+AmCr9+mgJN3z_xBxQ@mail.gmail.com>
 <CAE9FiQWvYQRCZjDx-Kh16nKfjfS=pyu8foJR+wWYS-x8DUZteg@mail.gmail.com>
 <CAJZOPZLVc=V-ac8_A2JB_r17TRyCMoDpe1MXN6WcjMR4SO6n1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZOPZLVc=V-ac8_A2JB_r17TRyCMoDpe1MXN6WcjMR4SO6n1Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 12:56:42AM -0400, Or Gerlitz wrote:
> > > Please note that this whole lockdep warning was identified as false
> > > positive by Tejun http://www.spinics.net/lists/linux-pci/msg21568.html
> >
> > No, at least one time, I noticed there is one real hang happens.
> 
> Tejun, so what your thinking here?

Can't really tell much without more details.  Yinghai, do you have any
logs from such hang?  Are you sure it's from this?

Thanks.

-- 
tejun
