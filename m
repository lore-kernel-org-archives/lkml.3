Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbaBCJhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 04:37:08 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:31500 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750894AbaBCJhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 04:37:06 -0500
Date: Mon, 3 Feb 2014 09:36:27 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: naveen yadav <yad.naveen@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        kernelnewbies <Kernelnewbies@kernelnewbies.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: Issue Float point in ARM WARNING: "__aeabi_d2iz"
Message-ID: <20140203093627.GA8006@arm.com>
References: <CAJ8eaTy28xjiQpGsdNLdpSsHzHVPSUimdcp=Pxn4L1YLNkq0SQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ8eaTy28xjiQpGsdNLdpSsHzHVPSUimdcp=Pxn4L1YLNkq0SQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 09:10:57AM +0000, naveen yadav wrote:
> We are using ARM SOC  cortex A15. we are running 3.10.x kernel. I am
> using gcc 4.6
> 
> I need floating  point in kernel module.

Try fixed point arithmetics ;). Floating point is not allowed in the
kernel.

-- 
Catalin
