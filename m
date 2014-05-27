Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbaE0RAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:00:54 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:39321 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbaE0RAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:00:53 -0400
Date: Tue, 27 May 2014 10:00:49 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/4] get_maintainer: shut up perl critic
Message-ID: <20140527100049.52f41546@nehalam.linuxnetplumber.net>
In-Reply-To: <1401154356.519.45.camel@joe-AO725>
References: <20140526203309.782169359@networkplumber.org>
	<1401152449.519.41.camel@joe-AO725>
	<1401152635.519.42.camel@joe-AO725>
	<20140526182207.34900c22@nehalam.linuxnetplumber.net>
	<1401154356.519.45.camel@joe-AO725>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2014 18:32:36 -0700
Joe Perches <joe@perches.com> wrote:

> On Mon, 2014-05-26 at 18:22 -0700, Stephen Hemminger wrote:
> > Use the no critic annotation, with comment, to silence perl critic
> > for places where the code is correct as is.
> 
> I think this uglifies the code and a more sensible solution
> is not using perlcritic
> 
> 

Perlcritic like checkpatch or sparse is a useful tool but often generates
false positives. Doing this allows shutting up the tool.
