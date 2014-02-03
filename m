Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbaBCP65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 10:58:57 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:46700 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbaBCP64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 10:58:56 -0500
MIME-Version: 1.0
In-Reply-To: <CAFrcx1mdRb6M24TsNWaZ6eEp2QFke3xvxqC2F96G7mdJ29t7JQ@mail.gmail.com>
References: <1390252922-25889-1-git-send-email-jean.pihet@linaro.org>
	<CAN7rbOstSYgZ39o68AA+z62Uj6KYzNhDkyX+sbHPr=xc-rRjRg@mail.gmail.com>
	<CAFrcx1nSDD4Sts7uDxxyG9LpyQiwFhby8oLEpWW-qotyWPpGpw@mail.gmail.com>
	<CAN7rbOti4ODDz9h_oMQpqdB5JWwL0wpB-7rzcbKxho_46pKawg@mail.gmail.com>
	<CAFrcx1mdRb6M24TsNWaZ6eEp2QFke3xvxqC2F96G7mdJ29t7JQ@mail.gmail.com>
Date: Mon, 3 Feb 2014 07:50:43 -0800
X-Google-Sender-Auth: V62w-u5hcFl5BV-L6qOMuMpmJVo
Message-ID: <CAN7rbOudSDZFwqeJg5=yYdCkCxWyxp1ZGyi1epQ=MpoXyLPaDQ@mail.gmail.com>
Subject: Re: [Libunwind-devel] [RFC PATCH 0/3] Add support for dwarf compat
 mode unwinding
From: Arun Sharma <arun@sharma-home.net>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        libunwind-devel <libunwind-devel@nongnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 3, 2014 at 7:28 AM, Jean Pihet <jean.pihet@linaro.org> wrote:

>> Something like ./configure --target=arm on aarch64.
>
> Thanks for the link and info.
>
> Is there a concrete example of cross-unwinding with multiple targets,
> for example on x86_64 using native and x86_32 libunwind libraries
> simultaneously?
> I am trying to assess the impact of multiple unwinding libs in the perf code.

Might want to check with folks who worked on Frysk. There was some
criticism that it was non-trivial, but it's been done.

http://lists.nongnu.org/archive/html/libunwind-devel/2007-05/msg00006.html

 -Arun
