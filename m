Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab3LCNd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:33:57 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:56347 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab3LCNdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:33:54 -0500
MIME-Version: 1.0
X-Originating-IP: [173.161.199.49]
In-Reply-To: <CABawtvNbkeXdQiBYD9Q+oRijw6VnT=FHdiFkjvFfh8Uw8KvO_A@mail.gmail.com>
References: <CAFi4uRvcUPvKvaeO5gZnjhMCFS+08MhEixJw-iN0AWbeBfiHvQ@mail.gmail.com>
 <CAErSpo7rbf7dwSZ12uoVXaf6HoRNDn0Pxxy-Vo_6F9kk+p07Qg@mail.gmail.com> <CABawtvNbkeXdQiBYD9Q+oRijw6VnT=FHdiFkjvFfh8Uw8KvO_A@mail.gmail.com>
From: Nick Pegg <nick@nickpegg.com>
Date: Tue, 3 Dec 2013 08:33:34 -0500
Message-ID: <CAFi4uRsuPUjxAOWuMkeBYd1fmT_CQdVdeffVRN1yxPVRcWuALA@mail.gmail.com>
Subject: Re: NETDEV WATCHDOG: eth0 (e1000e): transmit queue 0 timed out
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        Jin Feng <joe.jin@oracle.com>, konrad.wilk@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 2, 2013 at 10:51 PM, Ethan Zhao <ethan.kernel@gmail.com> wrote:
> Bjorn,
>    Seems not the same bug as  http://sourceforge.net/p/e1000/bugs/367/
> ,  Nick is not running his kernel on bare metal, per the error log,
> he runs his kernel as HVM DomU guest or Dom0 on XEN ?  so just a check
> of NULL will not fix that.
>

Sorry, I neglected to say in my original email that the kernel is
running as a Xen Dom0. Per Todd's request, I've opened a bug report on
sourceforge and will follow up with this issue there:
https://sourceforge.net/p/e1000/bugs/385/

Thanks,
Nick
