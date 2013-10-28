Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab3J1JJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 05:09:33 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44317 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab3J1JJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 05:09:32 -0400
X-AuditID: 9c93016f-b7cb6ae000000e4c-e2-526e29ca42dd
From: Namhyung Kim <namhyung@kernel.org>
To: Rodrigo Campos <rodrigo@sdfg.com.ar>
Cc: namhyung.kim@lge.com, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, asharma@fb.com, fweisbec@gmail.com
Subject: Re: State of "perf: Add a new sort order: SORT_INCLUSIVE"
References: <20131025150721.GA12534@sdfg.com.ar>
	<8761si9e1u.fsf@sejong.aot.lge.com>
	<20131028084244.GA7482@sdfg.com.ar>
Date: Mon, 28 Oct 2013 18:09:30 +0900
In-Reply-To: <20131028084244.GA7482@sdfg.com.ar> (Rodrigo Campos's message of
	"Mon, 28 Oct 2013 08:42:44 +0000")
Message-ID: <877gcx92yd.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Oct 2013 08:42:44 +0000, Rodrigo Campos wrote:
> On Mon, Oct 28, 2013 at 02:09:49PM +0900, Namhyung Kim wrote:
>> Anyway, You can find the series and discussion on the link below:
>> 
>>   https://lkml.org/lkml/2012/9/13/81
>
> I've read the cover letter for that series and probably because I don't know
> about perf internals I have a question: How will "--culumate" interact with
> "--sort=dso" for example ?
>
> I mean, is it possible for that to show more than 100% ? (if you add all the
> 93.35% in your example in the cover letter, or something similar). Or
> "--culumate --sort=dso" will just group together all entries that have a dso in
> the call chain ?

Hmm.. I think --cumulate option is only meaningful when sort order
includes symbol.  Maybe I can add support for --sort=dso case as well
but not sure it's worth.  Do you think it's really needed?

>
> Sorry if the question was too obvious if I knew about perf internals :S

No need to sorry about it. :)

Thanks,
Namhyung
