Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbaFCDL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 23:11:56 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49149 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaFCDLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 23:11:55 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools: lib: traceevent: parse-filter.c:  Cleaning up memory leak
References: <1401622616-13721-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Tue, 03 Jun 2014 12:11:52 +0900
In-Reply-To: <1401622616-13721-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	(Rickard Strandqvist's message of "Sun, 1 Jun 2014 13:36:56 +0200")
Message-ID: <87y4xed6vb.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rickard,

On Sun,  1 Jun 2014 13:36:56 +0200, Rickard Strandqvist wrote:
> There is a risk for memory leak in when something unexpected happens
> and the function returns.
>
> This was largely found by using a static code analysis program called cppcheck.

Nice work!

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
