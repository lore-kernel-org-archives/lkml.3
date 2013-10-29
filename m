Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab3J2UKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:10:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48676 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310Ab3J2UKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:10:35 -0400
Date: Tue, 29 Oct 2013 21:10:32 +0100
From: Jan Kara <jack@suse.cz>
To: John Twideldum <twideldums_throwaway@gmx.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.12-rc5 and overwritten partition table - by powertop?
Message-ID: <20131029201032.GC9568@quack.suse.cz>
References: <trinity-ee0bd2b5-ce28-4895-8c2a-2f60f40e49f4-1383046621263@3capp-gmx-bs07>
 <trinity-f65147f9-012f-4e78-a5a6-3f969ff5b9bf-1383058674646@3capp-gmx-bs07>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <trinity-f65147f9-012f-4e78-a5a6-3f969ff5b9bf-1383058674646@3capp-gmx-bs07>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29-10-13 15:57:54, John Twideldum wrote:
> replying to myself with more insights...
>  
> >0000000 13.00000\nalsa:hw
> >0000020 C0D0\t99.00000\nal
> >0000040 sa:hwC0D3\t99.000
> >0000060 00\nbacklight:acp
> >.....
> 
> The first ~170kb of /dev/sda got blown away with what seems to be a logging output
> by Powertop, when I was playing with the tuneables.
> (Luckily the first partition starts later :-))
  So did you log the output to some file? I'm just trying to understand how
it could get onto your disk in the first place...

> Why is that I don't know, but maybe when turning on the SATA knobs
> something goes wrong. I'm afraid to try again, but I accept rather higher
> power use than data loss again :-/

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
