Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbaIZNwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 09:52:11 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:59641 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbaIZNwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 09:52:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAL7Bo8G_7cOYxbtPR=JDxE8VJShbzs2+2Y=F9OOABgFZr=m29A@mail.gmail.com>
References: <1411725736-49225-1-git-send-email-huishao@microsoft.com>
	<CAL7Bo8HoYU1mbUbw-k0ufj7n8D=Z_hLtf268gKeyACcnZHH5rw@mail.gmail.com>
	<CD2CABCB2C0A0D4682C5F8AD8401415409846D@HKXPRD3002MB006.064d.mgd.msft.net>
	<CAL7Bo8G_7cOYxbtPR=JDxE8VJShbzs2+2Y=F9OOABgFZr=m29A@mail.gmail.com>
Date: Fri, 26 Sep 2014 14:52:07 +0100
Message-ID: <CAL7Bo8EocBnW28r-QtYU7AvSTyQNdMm39ns5WyM2++rbnJKxrg@mail.gmail.com>
Subject: Re: [PATCH] Drivers: hv: util: Implement Time Synchronization using
 host time sample
From: Mike Surcouf <mps.surcouf.lkml@gmail.com>
To: Thomas Shao <huishao@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        Olaf Hering <olaf@aepfle.de>, Robo Bot <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In CENTOS and RHEL 6 and upwards the official way would be to use

/usr/sbin/tickadj

which is provided by ntp/chrony package

This dependency on user space packages that may or may not be
installed is going to cause a lot of confusion in an already confused
space.
Are we sure theres no other way?
