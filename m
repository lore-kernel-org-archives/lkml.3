Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab3KBWe4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 18:34:56 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:39119 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab3KBWez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 18:34:55 -0400
Message-ID: <52757E0B.3010805@gmail.com>
Date: Sat, 02 Nov 2013 16:34:51 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Chenggang Qin <chenggang.qin@gmail.com>, linux-kernel@vger.kernel.org
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chenggang Qin <chenggang.qcg@taobao.com>
Subject: Re: [PATCH 2/4] perf tools: relate 'start' & 'end' to perf_session
References: <1383298146-3860-1-git-send-email-chenggang.qin@gmail.com> <1383298146-3860-3-git-send-email-chenggang.qin@gmail.com>
In-Reply-To: <1383298146-3860-3-git-send-email-chenggang.qin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/1/13, 3:29 AM, Chenggang Qin wrote:
> Copy the value to start and end to struct perf_session.

Why put the times in the session?

David

