Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603AbaAPAm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 19:42:28 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:52205 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbaAPAm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 19:42:26 -0500
X-AuditID: 9c93017d-b7b51ae000000e33-0e-52d72aef3569
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH/RFC] perf ui/tui: Show column header in hist browser
References: <1389762525-1795-1-git-send-email-namhyung@kernel.org>
	<20140115121044.GA1669@krava.redhat.com>
	<20140115141314.GA16016@ghostprotocols.net>
Date: Thu, 16 Jan 2014 09:42:23 +0900
In-Reply-To: <20140115141314.GA16016@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Wed, 15 Jan 2014 11:13:14 -0300")
Message-ID: <87ppns92q8.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo and Jiri,

On Wed, 15 Jan 2014 11:13:14 -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Jan 15, 2014 at 01:10:44PM +0100, Jiri Olsa escreveu:
>> On Wed, Jan 15, 2014 at 02:08:45PM +0900, Namhyung Kim wrote:
>> > Add a line for showing column headers like --stdio.
>> 
>> https://git.kernel.org/cgit/linux/kernel/git/jolsa/perf.git/commit/?h=perf/lock12&id=1a06d77629cb8870838132688f443b9ca1436026
>> 
>> ;-) I'll check your change
>
> From a quick view, your change looks better, i.e. being able to toggle
> the header line.
>
> Please let me know what you guys end up agreeing is best.

Yes, looking at the source, Jiri's version looks much better.  I was
lazy for sorting column width and supporting a hotkey for toggling. :)
I just wanted to see how you guys think, so the rfc.

Thanks,
Namhyung
