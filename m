Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaBLR7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 12:59:32 -0500
Received: from adamg.eu ([91.192.224.99]:48839 "EHLO adamg.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbaBLR7O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 12:59:14 -0500
From: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
To: Joe Perches <joe@perches.com>
Reply-To: pawel.sikora@agmk.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: [3.13.2] list passed to list_sort() too long for efficiency.
Date: Wed, 12 Feb 2014 18:59:07 +0100
Message-ID: <4850975.2GAlrTXDHt@localhost.localdomain>
User-Agent: KMail/4.12.2 (Linux/3.12.10-300.fc20.x86_64; KDE/4.12.2; x86_64; ; )
In-Reply-To: <1392227186.1868.20.camel@joe-AO722>
References: <1799469.xr2i5c36Hj@localhost.localdomain> <1392227186.1868.20.camel@joe-AO722>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 of February 2014 09:46:26 Joe Perches wrote:
> On Wed, 2014-02-12 at 18:16 +0100, Paweł Sikora wrote:
> > [16855.582522] list passed to list_sort() too long for efficiency
> > 
> > could someone put some light on the last line?
> 
> Did you look at the list_sort function in lib/list_sort.c?
> 
> (granted the dmesg is harder to find that it should be
>  because the format is split)
> 
> It just means it's slower than it could otherwise be

thanks,
so without a stacktrace in dmesg we can't isolate a root of cause :/

-- 
gpg key fingerprint = 60B4 9886 AD53 EB3E 88BB 1EB5 C52E D01B 683B 9411
