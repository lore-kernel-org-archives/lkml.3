Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaH3LYd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 07:24:33 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:42695 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbaH3LYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 07:24:31 -0400
Date: Sat, 30 Aug 2014 12:24:26 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>,
        Anders Darander <anders@chargestorm.se>, linux-efi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Harald Hoyer <harald@redhat.com>
Subject: Re: [PATCH] x86: only load initrd above 4g on second try
Message-ID: <20140830112426.GA2911@console-pimps.org>
References: <1409089544-24221-1-git-send-email-yinghai@kernel.org>
 <20140827105901.GC28116@console-pimps.org>
 <CAE9FiQWrPtEe3tkJjgOzyJJPPzX=AtMYgR4c91pDHL3q3ZLLKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQWrPtEe3tkJjgOzyJJPPzX=AtMYgR4c91pDHL3q3ZLLKQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug, at 10:13:22AM, Yinghai Lu wrote:
>
> How about adding more info print out like:
>   "Try to load initrd file to higher address..."

Yeah, that could work, at least we've had some debugging information to
go on if people start reporting hangs, though I'd suggest using "Trying"
or "Attempting".

-- 
Matt Fleming, Intel Open Source Technology Center
