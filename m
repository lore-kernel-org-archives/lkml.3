Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaBXPGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:06:54 -0500
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:49441 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbaBXPGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:06:53 -0500
Date: Mon, 24 Feb 2014 16:06:26 +0100
From: Guillaume Morin <guillaume@morinfr.org>
To: Jan Kara <jack@suse.cz>
Cc: Guillaume Morin <guillaume@morinfr.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Khalid Aziz <khalid.aziz@oracle.com>
Subject: Re: BUG: Bad page state in process with linux 3.4.76
Message-ID: <20140224150625.GA31414@bender.morinfr.org>
Mail-Followup-To: Jan Kara <jack@suse.cz>,
	Guillaume Morin <guillaume@morinfr.org>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Khalid Aziz <khalid.aziz@oracle.com>
References: <20140114203434.GA22994@bender.morinfr.org>
 <20140114221040.GA27903@bender.morinfr.org>
 <20140224113920.GA25547@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140224113920.GA25547@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 Feb 12:39, Jan Kara wrote:
>   I'm going through some old emails... Did this get resolved with later 3.4
> stable kernels? If not, I guess you should ping Greg / Khalid to either
> revert that commit (I guess preferable given the nature of the change) or
> merge some additional fixup...

Yes, it did get resolved.  Khalid backported
27c73ae759774e63313c1fbfeb17ba076cea64c5 which fixed the problem in the
mainline kernel and it was released in 3.4.79 as
50d8f1b5c57bb29f02ab5834be334b4f7922b856 (and included the other stable
branches as well).

Guillaume.

-- 
Guillaume Morin <guillaume@morinfr.org>
