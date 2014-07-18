Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934844AbaGRQM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 12:12:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:49073 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbaGRQMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 12:12:25 -0400
Message-ID: <53C94760.80106@linutronix.de>
Date: Fri, 18 Jul 2014 18:12:16 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, acme@kernel.org,
        namhyung.kim@lge.com, tzanussi@gmail.com
Subject: Re: [RFC] perf to ctf converter
References: <20140603163640.GA16279@linutronix.de> <20140714141533.GD17761@krava.redhat.com> <53C9143C.1060905@linutronix.de>
In-Reply-To: <53C9143C.1060905@linutronix.de>
X-Enigmail-Version: 1.6+git0.20140323
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 02:34 PM, Sebastian Andrzej Siewior wrote:
>> I made similar effort in C:
>>
>> ---
>> I made some *VERY* early perf convert example, mostly to try the ctf-writer
>> interface.. you can check in here:
>>   https://git.kernel.org/cgit/linux/kernel/git/jolsa/perf.git/log/?h=perf/ctf_2
> 
> Let me try it, maybe I can migrate my effort into one code basis.

FYI: I rebased your code antop of current tip-tree. The C-API looks
better. Especially since I can evlist__for_each() and create a list of
all events. So the C version might get cuter…


Sebastian
