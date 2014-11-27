Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344AbaK0Sbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 13:31:39 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:13625 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750729AbaK0Sbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 13:31:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuQNAGA2ZVRFpamy/2dsb2JhbABbgw5UWrlABpMxhnpVAoEcFwEBAQEBAXyEAgEBAQEDOB4iARALDgoJFgQLCQMCAQIBJxUJBg0BBwEBiD0N0HcBAQEBAQUBAQEBAQEchjqKWgeESwEEjAuLAohYPYYMhzSFQIF2gjaBZB+CewEBAQ
X-IPAS-Result: AuQNAGA2ZVRFpamy/2dsb2JhbABbgw5UWrlABpMxhnpVAoEcFwEBAQEBAXyEAgEBAQEDOB4iARALDgoJFgQLCQMCAQIBJxUJBg0BBwEBiD0N0HcBAQEBAQUBAQEBAQEchjqKWgeESwEEjAuLAohYPYYMhzSFQIF2gjaBZB+CewEBAQ
X-IronPort-AV: E=Sophos;i="5.07,380,1413259200"; 
   d="scan'208";a="98472540"
Message-ID: <54776E0A.1020508@voxpopuli.im>
Date: Thu, 27 Nov 2014 13:31:38 -0500
From: Alexandre Montplaisir <alexmonthy@voxpopuli.im>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Trace Compass Developer Discussions 
	<tracecompass-dev@eclipse.org>
Subject: Re: Support for Perf CTF traces now in master (was Re: FW: [RFC 0/5]
 perf tools: Add perf data CTF conversion)
References: <53F38C74.4030300@voxpopuli.im> <20140820092858.GA1203@krava.brq.redhat.com> <53F4F38C.4080407@voxpopuli.im> <5457C259.8030605@linutronix.de> <545829CA.7040900@voxpopuli.im> <20141105125028.GA30087@linutronix.de> <545AEA37.601@voxpopuli.im> <5460156E.3050601@voxpopuli.im> <5463DBD5.9080303@voxpopuli.im> <20141127154302.GA4924@krava.brq.redhat.com>
In-Reply-To: <20141127154302.GA4924@krava.brq.redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/27/2014 10:43 AM, Jiri Olsa wrote:
> On Wed, Nov 12, 2014 at 05:14:45PM -0500, Alexandre Montplaisir wrote:
>>
>> Testing welcome!
> hi,
> any other way besides compiling eclipse to test this? For pure mortals
> with Fedora eclipse rpm.. ;-)

If you already have an Eclipse installation, you can use the update site:
http://download.eclipse.org/tracecompass/master/nightly/
This would install the plugins into that Eclipse install.

We will also put nightly builds of the stand-alone version on the 
download page Very Soon(TM). We just have a few issues left to figure out.

Cheers,
Alexandre


