Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaHLHNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 03:13:05 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:55849 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbaHLHNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 03:13:04 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/8] perf tools: Make __hpp__fmt() receive an additional len argument
References: <1406785662-5534-1-git-send-email-namhyung@kernel.org>
	<1406785662-5534-3-git-send-email-namhyung@kernel.org>
	<20140802133026.GD13375@kernel.org>
	<87r40nfo36.fsf@sejong.aot.lge.com> <20140811131738.GB3277@kernel.org>
Date: Tue, 12 Aug 2014 16:13:01 +0900
In-Reply-To: <20140811131738.GB3277@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Mon, 11 Aug 2014 10:17:38 -0300")
Message-ID: <87iolyfaf6.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Mon, 11 Aug 2014 10:17:38 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Aug 11, 2014 at 05:05:33PM +0900, Namhyung Kim escreveu:
>> Hi Arnaldo,
>> 
>> On Sat, 2 Aug 2014 10:30:26 -0300, Arnaldo Carvalho de Melo wrote:
>> > Em Thu, Jul 31, 2014 at 02:47:36PM +0900, Namhyung Kim escreveu:
>> >> So that it can properly handle alignment requirements later.  To do
>> >> that, add percent_color_len_snprintf() fucntion to help coloring of
>> >> overhead columns.
>> >
>> > Can you elaborate on this description? What is not possible to do before
>> > this patch?
>> 
>> This patch is a preparation that moves hard-coded print width out of the
>> format string so that it can be passed from external settings later.
>
> Ok, please add this to the patch description?

Will do.  Btw, do you want me to resend the series?  It seems your tree
already merged it..

Thanks,
Namhyung
