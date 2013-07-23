Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009Ab3GWPUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:20:30 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:42369 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab3GWPU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:20:28 -0400
Message-ID: <51EE9F36.7050402@twiddle.net>
Date: Tue, 23 Jul 2013 07:20:22 -0800
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michael Cree <cree@waikato.ac.nz>
CC: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        ink@jurassic.park.msu.ru, mattst88@gmail.com,
        linux-alpha@vger.kernel.org
Subject: Re: [PATCH 0/7] Minor Alpha updates for 3.11
References: <20130717000347.GB2483@stolen.phys.waikato.ac.nz> <1374546701.3719.33@driftwood> <20130723032511.GA18086@stolen.phys.waikato.ac.nz>
In-Reply-To: <20130723032511.GA18086@stolen.phys.waikato.ac.nz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 07:25 PM, Michael Cree wrote:
> I wondered if your proposal will break glibc as glibc checks for
> __NR_oldumount and does different things based on that.  But maybe your
> fix will not adversely affect glibc (I did not look particularly closely
> to see if so), but even so, there is no guarantee that other software does
> not directly access the oldumount syscall when compiled on Alpha, and your
> change would likely break any such software.

It won't break glibc.  While there are conditionals for oldumount,
they do pretty much exactly the umount/umount2 dance you'd expect.

I'm for the patch, because anything that makes us match x86 more
closely has got to be a good thing from a portability standpoint.


r~
