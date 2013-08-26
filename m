Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab3HZLPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:15:47 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38890 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab3HZLPp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:15:45 -0400
From: Fabio Coatti <fabio.coatti@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.10.9 Crash
Date: Mon, 26 Aug 2013 13:15:41 +0200
Message-ID: <3209444.Rv0zN2ZK8h@calvin>
User-Agent: KMail/4.11 (Linux/3.10.9; KDE/4.11.0; x86_64; ; )
In-Reply-To: <20130826105930.GA25331@kroah.com>
References: <1681718.fu8vXZyU0z@calvin> <20130826105930.GA25331@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In data lunedì 26 agosto 2013 03:59:30, Greg Kroah-Hartman ha scritto:
> On Mon, Aug 26, 2013 at 10:36:30AM +0200, Fabio Coatti wrote:
> > Hi all,
> > I'm remotely managing a 3.10.9 server and this morning I found it locked.
> > The only data I could gather is a screenshot (thru AMT interface).
> > I've ran it thru gocr and this is the result (some char got garbled but
> > the
> > bulk is ok).
> > The machine is pretty new and stable, nothin like this happened with
> > previous 3.10.X
> 
> Can you reproduce this easily?  If so, can you use 'git bisect' to track
> down the offending patch?


I wish I could :). I thinked of it, but looking at logs I spotted no clues 
about reproducing the issue. The server is pretty unused, the only thing that 
I can imagine happening at more or less the time of crash is a logrotation. I 
launched it again with no problems, but of course things can be different.
Right now I'm using that server with no problems,  (emerging packages and so 
on) but of course is not a proof of anything.
The only thing a bit weird on that system (if it can be considered as such) is 
a raid+lvm+btrfs stack (not a important production server )
--
Fabio
