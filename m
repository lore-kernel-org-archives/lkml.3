Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab3CLLfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:35:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115Ab3CLLfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:35:02 -0400
Date: Tue, 12 Mar 2013 08:34:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] EDAC fixes for 3.8
Message-ID: <20130312083448.6f3ce5f9@redhat.com>
In-Reply-To: <20130312091630.GC5455@pd.tnic>
References: <20121211140108.GC4303@liondog.tnic>
	<20130307095703.03d040ee@redhat.com>
	<20130307130635.GD5239@pd.tnic>
	<20130307110213.7a5a9978@redhat.com>
	<20130309154635.GA18316@pd.tnic>
	<20130311090746.199a4c06@redhat.com>
	<20130311092848.652c0d46@redhat.com>
	<20130312085855.GB5455@pd.tnic>
	<20130312091630.GC5455@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 12 Mar 2013 10:16:30 +0100
Borislav Petkov <bp@alien8.de> escreveu:

> Btw,
> 
> the first one I changed to not divide by the channel_count, see below.
> Now I'll go and run them to check everything's fine.

Looks ok on my eyes. I'll test it here on both systems, with both this
patch and the second one:

http://git.infradead.org/users/mchehab/edac.git/commitdiff/56ba4c93d909ef9dfab4f1101a8c3bf75bc4cdab

It should take some time to finish compilation.

Thanks!
Mauro
