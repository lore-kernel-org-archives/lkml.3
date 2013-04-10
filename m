Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936151Ab3DJA4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 20:56:08 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:59457 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765432Ab3DJA4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 20:56:06 -0400
MIME-Version: 1.0
In-Reply-To: <20130409072801.GB31193@intel.com>
References: <20130326223953.15072.26605.stgit@djiang5-linux2.ch.intel.com>
	<20130409072801.GB31193@intel.com>
Date: Tue, 9 Apr 2013 17:56:04 -0700
X-Google-Sender-Auth: qpbWkqV--wkA3c5eAqmPoh01N1c
Message-ID: <CAA9_cmewnoSrcLp6Wb0b+rhqS23s5uwPq5Dih0ThtDQG7QARiQ@mail.gmail.com>
Subject: Re: [PATCH 00/10] Add Intel Atom S1200 seris ioatdma support
From: Dan Williams <djbw@fb.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 12:28 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Tue, Mar 26, 2013 at 03:42:29PM -0700, Dave Jiang wrote:
>> The following series adds support for the Intel Atom S1200 product family
>> ioatdma. This ioatdma also implements a set of version v3.3 features such as 16
>> sources PQ, descriptor write back error status, and does not have many of the
>> silicon bugs that the 3.2 line of hardware has due to a brand new implemention.
>>
>> The series is dependent on the haswell update patch sent prior.
> Hey Dan,
>
> Are you okay with the series. Merge window is very close...
>

[resend, last one got html formatted/rejected]

Hi Vinod, thanks for the ping.

Chatted with Dave patches 1-3 and 5-8, and 10 are reviewed/acked.  For
patch 4 and 9 we think we have a slightly cleaner way to organize the
quirk handling and an update will be coming.

--
Dan
