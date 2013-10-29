Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab3J2R7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 13:59:44 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:49777 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab3J2R7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 13:59:42 -0400
Message-ID: <526FF78B.10708@linux.com>
Date: Tue, 29 Oct 2013 18:59:39 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: levex@linux.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: John Schmidt <johnschmidt4@gmail.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mdadm.8.in
References: <CACcY5Uxc2f6HOxLHt5DY5E71EvFbo0dNmtqUtH=FRwTitE=+zw@mail.gmail.com>
In-Reply-To: <CACcY5Uxc2f6HOxLHt5DY5E71EvFbo0dNmtqUtH=FRwTitE=+zw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-10-29 18:16 keltezéssel, John Schmidt írta:
> I found a small bug in the documentation of mdadm.  I fixed it in my
> local git clone of git://neil.brown.name/mdadm  Here is the change:
> 
> git diff mdadm.8.in
> diff --git a/mdadm.8.in b/mdadm.8.in
> index 09aff81..006ae59 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -529,7 +529,7 @@ amount of available space is.
>  .BR \-c ", " \-\-chunk=
>  Specify chunk size of kibibytes.  The default when creating an
>  array is 512KB.  To ensure compatibility with earlier versions, the
> -default when Building and array with no persistent metadata is 64KB.
> +default when building an array with no persistent metadata is 64KB.
>  This is only meaningful for RAID0, RAID4, RAID5, RAID6, and RAID10.
> 
>  RAID4, RAID5, RAID6, and RAID10 require the chunk size to be a power
> 
> Let me know if there are other things I need to do to get this patch submitted.

Hi,

I don't think this belongs to LKML.
I am not familiar with linux-raid but I think that the following guidelines
do apply there as well.

https://www.kernel.org/doc/Documentation/SubmittingPatches

Other than this, the patch is a legitimate one, I am sure it will be accepted.


--
Regards,
Levente Kurusa
