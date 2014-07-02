Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaGBJCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 05:02:17 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:41731 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbaGBJCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 05:02:13 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ekfyrejs0ialTxoYXnIEza2FTPybMoi18A
X-RZG-CLASS-ID: mo00
Message-ID: <53B3CA91.5000002@schoebel-theuer.de>
Date: Wed, 02 Jul 2014 11:02:09 +0200
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Thomas_Sch=F6bel-Theue?= =?ISO-8859-1?Q?r?= 
	<tst@1und1.de>
Subject: Re: [PATCH 49/50] mars: generic pre-patch for mars
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de> <1404251250-22992-50-git-send-email-tst@schoebel-theuer.de> <20140701223644.GA30330@kroah.com> <53B3B283.7050800@schoebel-theuer.de> <20140702082400.GB10971@kroah.com>
In-Reply-To: <20140702082400.GB10971@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maintaining out of tree code is not our problem, sorry. thanks, greg k-h 

OK, I just noticed that in the meantime many vfs_*() are present now
which were missing when I started the project on very old kernels (or
maybe I missed something, sorry for any potential mistakes).

So I will happily make a new version which has the lowest possible
footprint in the kernel, but nevertheless is _internally_ portable (just
for me and the needs of 1&1 users).

This will incur many changes in many places in the patchset. Is it OK to
re-submit the _whole_ patchset again after that?

I will have to re-run the full testsuite on the new version in order to
be sure that no bad things happen, so this will take at least 24h (if
not several days).

Cheers,

Thomas
