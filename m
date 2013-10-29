Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab3J2WUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 18:20:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52573 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab3J2WUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 18:20:05 -0400
Date: Tue, 29 Oct 2013 23:20:02 +0100
From: Jan Kara <jack@suse.cz>
To: John Twideldum <twideldums_throwaway@gmx.at>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: 3.12-rc5 and overwritten partition table - by powertop?
Message-ID: <20131029222002.GD12814@quack.suse.cz>
References: <trinity-ee0bd2b5-ce28-4895-8c2a-2f60f40e49f4-1383046621263@3capp-gmx-bs07>
 <trinity-f65147f9-012f-4e78-a5a6-3f969ff5b9bf-1383058674646@3capp-gmx-bs07>
 <20131029201032.GC9568@quack.suse.cz>
 <trinity-93870424-b236-4b3e-be8c-7af706430adc-1383083920353@3capp-gmx-bs31>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-93870424-b236-4b3e-be8c-7af706430adc-1383083920353@3capp-gmx-bs31>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29-10-13 22:58:40, John Twideldum wrote:
> >> The first ~170kb of /dev/sda got blown away with what seems to be a logging output
> >> by Powertop, when I was playing with the tuneables.
> >
> >So did you log the output to some file? I'm just trying to understand how
> >it could get onto your disk in the first place...
> 
> Attached a dump of the first 1Mb of the disk, HTH.
> It looks like a powertop log?
> (I have powertop 2.4)
  Yes, likely. But it is strange the corruption doesn't even end at any
sensible boundary (data ends at offset 0x27b53). Shrug...

> meanwhile, testdisk running in all variations recovered enough clues to
> guess the partitions correctly - the data is fine :-)
  Good.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
