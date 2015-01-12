Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbbALTEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:04:04 -0500
Received: from www.sr71.net ([198.145.64.142]:60107 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328AbbALTEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:04:01 -0500
Message-ID: <54B41A9E.4030705@sr71.net>
Date: Mon, 12 Jan 2015 11:03:58 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Laszlo Ersek <lersek@redhat.com>, Mark Langsdorf <mlangsdo@redhat.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Steve Capper <steve.capper@linaro.org>,
        "vishnu.ps@samsung.com" <vishnu.ps@samsung.com>,
        main kernel list <linux-kernel@vger.kernel.org>,
        arm kernel list <linux-arm-kernel@lists.infradead.org>,
        Kyle McMartin <kmcmarti@redhat.com>
Subject: Re: Linux 3.19-rc3
References: <20150109121348.GD12942@leverpostej> <CAPvkgC23LHhs7Tw4rdAPFooimonji8R7kEAbWYRKPJwouwUzBA@mail.gmail.com> <54AFE53A.4020004@redhat.com> <20150109175702.GA27787@leverpostej> <54B01FF0.3020900@arm.com> <20150109194333.GA23028@arm.com> <54B09CA3.1060501@redhat.com> <CA+55aFw3aGeiWOiKxQaC23VVX_Q9B0cDeZc37vVfK+SJVjGwFw@mail.gmail.com> <20150110133742.GA6999@arm.com> <CA+55aFxBA6F4Kr89iZwPPeBnkiRO4GnrbUSd0CqVG-LD6ZQyiw@mail.gmail.com> <20150112124256.GB13360@arm.com>
In-Reply-To: <20150112124256.GB13360@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 04:42 AM, Will Deacon wrote:
> Since this effectively reverts f045bbb9fa1b, I've added Dave to Cc. It
> should fix the leak without reintroducing the performance regression.

I ran this on the big system that showed the earlier issue.  Everything
seems OK, at least with the test that showed the issue earlier (the brk1
test from will-it-scale).
