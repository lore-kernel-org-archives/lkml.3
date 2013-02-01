Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab3BAVMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 16:12:34 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:42270 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473Ab3BAVMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 16:12:31 -0500
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Feb 2013 16:12:31 EST
MIME-Version: 1.0
In-Reply-To: <1359733687.17807.7.camel@joe-AO722>
References: <20130201154306.GA28473@kroah.com>
	<1359733687.17807.7.camel@joe-AO722>
Date: Fri, 1 Feb 2013 23:07:26 +0200
Message-ID: <CAJL_dMuMnq0=4vv0GriQqUhwnR=gwcnok3rXTsanVYZ5cdLfkQ@mail.gmail.com>
Subject: Re: [PATCH] SubmittingPatches: add penalty for forcing a maintainer
 to edit a patch
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe, read lkml and decide after that.
I fully apove the pathch.

Reviewed-by: Anca Emanuel <anca.emanuel@gmail.com>

Review-requested-by: Joe Perches <joe@perches.com>


Comments:
You have 3 kernels to maintain as stable, plus drivers, plus etc.
If somebody post something without reading the docs, and you have to
repeat to them the same, again and more, then you MUST give an beer.

On Fri, Feb 1, 2013 at 5:48 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2013-02-01 at 16:43 +0100, Greg Kroah-Hartman wrote:
>> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>
>> Maintainers have to hand-edit patches (body of patches and changelog
>> entries) all the time.  There needs to be some kind of penalty put into
>> place to keep developers from abusing maintainers.
>
> No, there doesn't.
>
> It's funny as a joke, it's not as an actual patch.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
