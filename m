Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbbALP14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:27:56 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:47238 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbbALP1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:27:55 -0500
MIME-Version: 1.0
In-Reply-To: <20150112151625.GA30247@csclub.uwaterloo.ca>
References: <54AC72AF.5090609@landley.net>
	<20150112151625.GA30247@csclub.uwaterloo.ca>
Date: Mon, 12 Jan 2015 16:27:54 +0100
Message-ID: <CAFLxGvyyujXptcD3d6AF+Fri+UC_G1n8ED+uJZZ0TuD22kszow@mail.gmail.com>
Subject: Re: [PATCH] out out damn perl
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Rob Landley <rob@landley.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 4:16 PM, Lennart Sorensen
<lsorense@csclub.uwaterloo.ca> wrote:
> On Tue, Jan 06, 2015 at 05:41:35PM -0600, Rob Landley wrote:
>> From: Rob Landley <rob@landley.net>
>>
>> Commit e6023367d779 added perl back to the kernel build in -rc6.
>> Replace 39 lines of perl with 4 lines of shell script.
>
> Maybe checkpatch should be updated to look for perl. :)

Yeah, then checkpatch.pl warn on itself. ;-)

-- 
Thanks,
//richard
