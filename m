Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763AbaJUNkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:40:10 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54156 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932556AbaJUNkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:40:08 -0400
Date: Tue, 21 Oct 2014 15:39:59 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Markos Chandras <Markos.Chandras@imgtec.com>
Cc: linux-mips@linux-mips.org, Jonathan Corbet <corbet@lwn.net>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Foley <pefoley2@pefoley.com>
Subject: Re: [PATCH] Documentation: ptp: Fix build failure on MIPS cross
 builds
Message-ID: <20141021133959.GC16479@netboy>
References: <1413794538-28465-1-git-send-email-markos.chandras@imgtec.com>
 <20141021110724.GA16479@netboy>
 <54464D6A.5000501@imgtec.com>
 <20141021125240.GB16479@netboy>
 <544659B1.6070509@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544659B1.6070509@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 02:03:45PM +0100, Markos Chandras wrote:
> 
> Hmm I can't see this testptp.mk file in the mainline. What tree are you
> referring to?

Sorry, I have net-next open in front of me. The same guy who added
the buggy Makefile deleted my working makefile...

Thanks,
Richard
