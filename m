Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbaBLSN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:13:29 -0500
Received: from adamg.eu ([91.192.224.99]:49026 "EHLO adamg.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685AbaBLSN2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:13:28 -0500
From: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
To: Dave Jones <davej@redhat.com>
Reply-To: pawel.sikora@agmk.net
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [3.13.2] list passed to list_sort() too long for efficiency.
Date: Wed, 12 Feb 2014 19:13:21 +0100
Message-ID: <5006918.CkfDURZEXl@localhost.localdomain>
User-Agent: KMail/4.12.2 (Linux/3.12.10-300.fc20.x86_64; KDE/4.12.2; x86_64; ; )
In-Reply-To: <20140212180356.GA28354@redhat.com>
References: <1799469.xr2i5c36Hj@localhost.localdomain> <4850975.2GAlrTXDHt@localhost.localdomain> <20140212180356.GA28354@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 of February 2014 13:03:56 Dave Jones wrote:
> On Wed, Feb 12, 2014 at 06:59:07PM +0100, Paweł Sikora wrote:
>  > On Wednesday 12 of February 2014 09:46:26 Joe Perches wrote:
>  > > On Wed, 2014-02-12 at 18:16 +0100, Paweł Sikora wrote:
>  > > > [16855.582522] list passed to list_sort() too long for efficiency
>  > > > 
>  > > > could someone put some light on the last line?
>  > > 
>  > > Did you look at the list_sort function in lib/list_sort.c?
>  > > 
>  > > (granted the dmesg is harder to find that it should be
>  > > 
>  > >  because the format is split)
>  > > 
>  > > It just means it's slower than it could otherwise be
>  > 
>  > thanks,
>  > so without a stacktrace in dmesg we can't isolate a root of cause :/
> 
> The commit message mentions xfs and ubifs have long lists that get
> passed in. Do you use either of those ?

this is a test-farm server which utilizes only cpu/ext4/nfs/lvm/mdadm.

-- 
gpg key fingerprint = 60B4 9886 AD53 EB3E 88BB 1EB5 C52E D01B 683B 9411
