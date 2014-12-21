Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbaLUSHe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 13:07:34 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:46367 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbaLUSHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 13:07:32 -0500
MIME-Version: 1.0
In-Reply-To: <20141218001123.GA6548@kroah.com>
References: <1418853900-6887-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20141218001123.GA6548@kroah.com>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sun, 21 Dec 2014 19:07:11 +0100
Message-ID: <CAFo99gb=fkupq7N=EMuk0RJCpCY2r21u1w+B05YjoqZ_s1ruXA@mail.gmail.com>
Subject: Re: [PATCH] staging: lustre: lustre: obdclass: lprocfs_status.c:
 Removed an unnecessary NULL check
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>, devel@driverdev.osuosl.org,
        HPDD-discuss@ml01.01.org, Greg Donald <gdonald@gmail.com>,
        James Simmons <uja.ornl@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fabian Frederick <fabf@skynet.be>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        "John L. Hammond" <john.hammond@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-18 1:11 GMT+01:00 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> On Wed, Dec 17, 2014 at 11:05:00PM +0100, Rickard Strandqvist wrote:
>> Removed an unnecessary NULL check. And clarified a switch statement.
>
> That's two different things, please only do one thing in a patch, so
> this would be 2 different patches.
>
> please fix up and resend as a series of patches.
>
> thanks,
>
> greg k-h



Ok, sorry new path on the way!

Kind regards
Rickard Strandqvist
