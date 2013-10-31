Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab3JaQQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:16:00 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:48322 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab3JaQP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:15:58 -0400
MIME-Version: 1.0
In-Reply-To: <20131031155503.GO1935@sgi.com>
References: <5265C03B.50701@sandeen.net>
	<20131022001732.GI4446@dastard>
	<CAGG-pUTh-PJJ4Nzo0r-f3VDPMc81U2z_NMX+Wcex3KzGs=U8cA@mail.gmail.com>
	<20131022203946.GB2797@dastard>
	<5266E4BD.8030601@sandeen.net>
	<20131022210300.GC2797@dastard>
	<5266EBF0.901@sandeen.net>
	<CAGG-pUTtYomspBXn=RE7YFU=vu6rWZ1fU7CBO45Mmodj8DZFiQ@mail.gmail.com>
	<20131023203435.GR1935@sgi.com>
	<5271672C.7070101@sandeen.net>
	<20131031155503.GO1935@sgi.com>
Date: Thu, 31 Oct 2013 14:15:57 -0200
Message-ID: <CAGG-pUQawQ0WGkL9tovQ+ejpmAvEpkrOB-uznD03SjBMUcmAJA@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix possible NULL dereference
From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
To: Ben Myers <bpm@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Alex Elder <elder@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        XFS FILESYSTEM <xfs@oss.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/31 Ben Myers <bpm@sgi.com>:
> Hey Geyslan,
>
> On Wed, Oct 30, 2013 at 03:08:12PM -0500, Eric Sandeen wrote:
>> On 10/23/13 3:34 PM, Ben Myers wrote:
>>
>> > xfs: fix possible NULL dereference in xlog_verify_iclog
>> >
>> > In xlog_verify_iclog a debug check of the incore log buffers prints an
>> > error if icptr is null and then goes on to dereference the pointer
>> > regardless.  Convert this to an assert so that the intention is clear.
>> > This was reported by Coverty.
>> >
>> > Reported-by: Geyslan G. Bem <geyslan@gmail.com>
>> > Signed-off-by: Ben Myers <bpm@sgi.com>
>>
>> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>
> Applied this.  Many thanks!  ;)
>
> -Ben

It was a pleasure. o/

-- 
Regards,

Geyslan G. Bem
hackingbits.com
