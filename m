Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab3JDPdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 11:33:40 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:33012 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825Ab3JDPdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 11:33:38 -0400
Message-ID: <524EDFCD.5090207@gmail.com>
Date: Fri, 04 Oct 2013 09:33:33 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Sonny Rao <sonnyrao@chromium.org>
Subject: Re: [PATCH] perf session: Fix infinite loop on invalid perf.data
 file
References: <1380529188-27193-1-git-send-email-namhyung@kernel.org> <20131001071646.GA20023@gmail.com> <524ACD2A.7040902@gmail.com> <20131001142154.GA31298@gmail.com> <524ADF84.4080801@gmail.com> <20131001153309.GA1287@gmail.com> <20131001165437.GF2920@ghostprotocols.net> <524AFF5A.3030909@gmail.com> <20131004152524.GA2265@ghostprotocols.net>
In-Reply-To: <20131004152524.GA2265@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/4/13 9:25 AM, Arnaldo Carvalho de Melo wrote:
> Got to process this now, changing it a bit to replace "perf.data" with
> "%s" + session->filename, ack?
>
> Otherwise the user may have a 'perf.data' file and despite having
> informed -i with a different file name still get confused... ;-)
>

ack. agreed that's the better way to go.

David

