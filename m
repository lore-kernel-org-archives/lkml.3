Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaJITNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:13:45 -0400
Received: from webbox4.loswebos.de ([213.187.93.205]:50897 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaJITNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:13:16 -0400
Date: Thu, 9 Oct 2014 21:13:07 +0200
From: Marc Burkhardt <marc@osknowledge.org>
To: Marc Burkhardt <marc@osknowledge.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: acpitool - /proc/acpi/wakeup
Message-ID: <20141009191307.GB5428@localhost>
References: <20141009190406.GA5428@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009190406.GA5428@localhost>
X-PGP-Fingerprint: D514 7DC1 B5F5 8989 083E 38C9 5ECF E5BD 3430 ABF5
X-PGP-Key: http://marc.ngoe.de/pubkey.asc
X-Operating-System: Linux marc 3.17.0-desper
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marc Burkhardt <marc@osknowledge.org> [2014-10-09 21:04:06 +0200]:

Just another note: the process uses 100% CPU while 'waiting' for further data it
seems...

strace shows nothing suspicious.

Thanks,
Marc

> Hi there,
> I noticed, that 'acpitool -e' doesn't work any longer sind I upgraded to 3.17.
> The tool stalls at
> 
>    Device       S-state   Status   Sysfs node
>   ---------------------------------------
>   1. LID          S3    *enabled   platform:PNP0C0D:00
>   2. SLPB         S3    *enabled   platform:PNP0C0E:0
> 
> Before there were 11 entries shown.
> 
> Can I help investigate it?
> 
> Thanks,
> Marc
> 
> -- 
> Marc Burkhardt

-- 
Marc Burkhardt
