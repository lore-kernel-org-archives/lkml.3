Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaFXHRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 03:17:33 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:55047 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaFXHRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 03:17:32 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Stanislav Fomichev <stfomichev@yandex-team.ru>, a.p.zijlstra@chello.nl,
        paulus@samba.org, mingo@redhat.com, dsahern@gmail.com,
        jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] perf trace pagefaults
References: <1403261389-13423-1-git-send-email-stfomichev@yandex-team.ru>
	<20140620132105.GE31524@kernel.org>
Date: Tue, 24 Jun 2014 16:17:25 +0900
In-Reply-To: <20140620132105.GE31524@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Fri, 20 Jun 2014 10:21:05 -0300")
Message-ID: <87wqc66aka.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo and Stanislav,

On Fri, 20 Jun 2014 10:21:05 -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Jun 20, 2014 at 02:49:42PM +0400, Stanislav Fomichev escreveu:
>> This patch series adds support for pagefaults tracing to 'perf trace' command.
>> It seems this feature was planned by Namhyung Kim (http://events.linuxfoundation.org/images/stories/pdf/klf2012_n_kim.pdf page 17/28)
>> but I couldn't find any prior patches/discussion and started from scratch.
>
> Just to clarify here, those slides came from slides I made and in turn
> the whole idea about pagefaults tracing I got from the trace prototype
> that Thomas Gleixner implemented in his 'trace'  utility, described
> here:
>
>   Announcing a new utility: 'trace'
>   http://lwn.net/Articles/415728/

Right, I asked to Arnaldo to suggest some cool topics to introduce in
KLF 2012 and that was it.   I had nothing with the features. :)

Keep going nice works, guys!

Thanks,
Namhyung
