Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbaFSPUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:20:15 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:60743 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423AbaFSPUN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:20:13 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: tdjames <tdjames@umd.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to disable Lazy Preempt in the kernel
Date: Thu, 19 Jun 2014 17:20:08 +0200
Message-ID: <5874558.fsfNbcCYz9@merkaba>
User-Agent: KMail/4.14 pre (Linux/3.15.0-tp520; KDE/4.13.1; x86_64; git-354479a; 2014-06-15)
In-Reply-To: <1403190681610-885003.post@n7.nabble.com>
References: <1403190681610-885003.post@n7.nabble.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 19. Juni 2014, 08:11:21 schrieb tdjames:
> I'm relatively new to Linux and working on getting a real-time kernel up and
> running for robot applications. I'm on Ubuntu 14.04, using kernel 3.14.3
> and the 3.14.3-rt5 real-time patch. Also using x86-64.

I don´t know about lazy preempt, but maybe a search in make nconfig reveals 
more?

In any case: Debian offers ready made rt kernels as packages. So maybe thats an 
option for you? Beware: Debian and Ubuntu kernel packaging is different. Maybe 
Ubuntu also has a rt kernel package?

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
