Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbaBXH4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 02:56:46 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:33480 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbaBXH4p convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Mon, 24 Feb 2014 02:56:45 -0500
Message-Id: <530B0948020000780011E968@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 24 Feb 2014 07:56:40 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <davem@davemloft.net>, "Ingo Molnar" <mingo@kernel.org>,
        <tglx@linutronix.de>, <dborkman@redhat.com>, <ffusco@redhat.com>,
        <tgraf@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86/hash: fix build failure with older
 binutils
References: <53073962020000780011E2DE@nat28.tlf.novell.com>
 <68ae560f-8cf7-4083-816f-3fa78aed9a87@email.android.com>
 <53076DBC020000780011E552@nat28.tlf.novell.com>
 <5307A651.5030604@zytor.com>
In-Reply-To: <5307A651.5030604@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 21.02.14 at 20:17, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 02/21/2014 06:16 AM, Jan Beulich wrote:
>>>>> On 21.02.14 at 13:51, "H. Peter Anvin" <hpa@zytor.com> wrote:
>>> How old?
>> 
>> 2.16.91.0.5 (SLE10)
>> 
> 
> I would *love* to kill off binutils 2.16.  It was a horribly buggy
> version, and it has been hard to deal with keeping things alive with it.
>  How important is this?
> 
> Since this is the first I've heard of this being broken, I am kind of
> encouraged that maybe we can move on?

2.17 doesn't have support for it either, yet has support for fxsaveq
(which you can see in the patch context we check for too). Apart
from that Documentation/Changes continues to state binutils 2.12
to be the minimum requirement...

Jan

