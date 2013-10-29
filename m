Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab3J2V6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:58:42 -0400
Received: from mout.gmx.net ([212.227.17.20]:64274 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135Ab3J2V6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:58:41 -0400
MIME-Version: 1.0
Message-ID: <trinity-93870424-b236-4b3e-be8c-7af706430adc-1383083920353@3capp-gmx-bs31>
From: "John Twideldum" <twideldums_throwaway@gmx.at>
To: "Jan Kara" <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.12-rc5 and overwritten partition table - by powertop?
Content-Type: multipart/mixed;
 boundary=rehcsedm-bf5307ab-bd51-475a-8eca-c6d411264793
Date: Tue, 29 Oct 2013 22:58:40 +0100 (CET)
Importance: normal
Sensitivity: Normal
In-Reply-To: <20131029201032.GC9568@quack.suse.cz>
References: <trinity-ee0bd2b5-ce28-4895-8c2a-2f60f40e49f4-1383046621263@3capp-gmx-bs07>
 <trinity-f65147f9-012f-4e78-a5a6-3f969ff5b9bf-1383058674646@3capp-gmx-bs07>,
 <20131029201032.GC9568@quack.suse.cz>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K0:/11kMkw+3jrJOps0WEIZmz3DpxaraDY7kyd3owT1FVR
 YiaBS0+Fb89zkF/I8GISTUwI6PXGnbH6UIXc5VnngacBCnIv7H
 hSdpdKQP0wxtiBIRrIxkqqJIwWgc7MMEG9PwMKJ+TP3ig7DVwB
 My0Mjc0+Ml+J7uKvGVnoLe+Oo0ONP0SyAZZZDSj0VZU1inq7LX
 tl7lVUbVxcmIDk1p6QzOxR9AK+OXYO5rVjx4Pg07iAv6Bw6Dnv
 +mRVnvuj4bW+UoVVhZ8t6iWTH/YEo3HTVgzfRB3vhxWkpQgaxa 4Yt+aY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--rehcsedm-bf5307ab-bd51-475a-8eca-c6d411264793
Content-Type: text/plain; charset=UTF-8

>> The first ~170kb of /dev/sda got blown away with what seems to be a logging output
>> by Powertop, when I was playing with the tuneables.
>
>So did you log the output to some file? I'm just trying to understand how
>it could get onto your disk in the first place...

Attached a dump of the first 1Mb of the disk, HTH.
It looks like a powertop log?
(I have powertop 2.4)

meanwhile, testdisk running in all variations recovered enough clues to
guess the partitions correctly - the data is fine :-)

J

--rehcsedm-bf5307ab-bd51-475a-8eca-c6d411264793
Content-Type: application/x-bzip2
Content-Disposition: attachment; filename=backup_overwrite.dump.bz2
Content-Transfer-Encoding: base64

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
U4UJBvvH/jA=
--rehcsedm-bf5307ab-bd51-475a-8eca-c6d411264793--
