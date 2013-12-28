Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab3L1AQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 19:16:16 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:48576 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab3L1AQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 19:16:10 -0500
MIME-Version: 1.0
In-Reply-To: <20131223115439.GA22852@krava.brq.redhat.com>
References: <CAMesUR48C3zBo_UJByjC9GSqK6V=W_-WDQrsAoGye2yNADD3NQ@mail.gmail.com>
	<52B4E815.8030304@gmail.com>
	<20131223115439.GA22852@krava.brq.redhat.com>
Date: Sat, 28 Dec 2013 01:16:09 +0100
Message-ID: <CAMesUR6-OH9KTOMpBp=45vnNjD2mK_4V0i8ETuR2ONmzg4sCrg@mail.gmail.com>
Subject: Re: perf and Kconfig
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just checked your branch perf/kbuild9.

Your work is far more elaborate than mine. In my branch, I just reused
the *config targets so as to generate the files .config
include/config/auto.conf(.cmd), ...; after that, I manually modified
Makefile.perf with the variables CONFIG_* instead of using the whole
Kbuild system.

Thank you for your mail, it helped me a lot.

Alexis.

On Mon, Dec 23, 2013 at 12:54 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Fri, Dec 20, 2013 at 06:00:05PM -0700, David Ahern wrote:
>> [adding perf maintainers]
>>
>> On 12/20/13, 5:39 PM, Alexis Berlemont wrote:
>> >Hi,
>> >
>> >Here is a proposal of a small contribution which tries to fulfill the
>> >task "Use Kconfig to allow selecting features and build minimal
>> >version of perf,..." displayed on the todo page of the perf
>> >wiki (https://perf.wiki.kernel.org/index.php/Todo).
>> >
>> >I tried to continue the work started by David Ahern
>> >(https://github.com/dsahern/linux.git branch:perf-config). This
>> >version relies on the features detection tests available in
>> >linux/tools/perf/config/feature-checks so as to enable some
>> >configuration options (at least by default).
>> >
>> >This little task is not complete; more Kconfig options should be added
>> >for each perf tool (top, record, report, ...).
>> >
>> >I just wanted to ask whether you consider this proposal as interesting
>> >enough for inclusion and if you are ok with the way it is implemented.
>> >
>> >The code is available here: https://github.com/aberlemont/linux.git
>> >- branch: perf-config.
>>
>> I know Jiri has an attempt in his tree and there have been a few
>> discussions since then as well. I'll take a look at it next week. I
>> would like to see it completed; I just don't have the time to do it.
>
> hi,
> my latest branch (out of sync for long time) for kbuild:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>   perf/kbuild9
>
> I'll check your changes ;-)
>
> jirka
