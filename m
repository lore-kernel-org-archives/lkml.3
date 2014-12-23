Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbaLWEYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 23:24:46 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44710 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbaLWEYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 23:24:45 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
Date: Tue, 23 Dec 2014 13:25:25 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools: lib: traceevent: kbuffer-parse.c:  Remove some
 unused functions
Message-ID: <20141223042525.GE14960@sejong>
References: <1419093600-8306-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1419093600-8306-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2014 at 05:40:00PM +0100, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> kbuffer_set_old_format() kbuffer_missed_events() kbuffer_curr_size()
> kbuffer_event_size() kbuffer_curr_offset() kbuffer_curr_index()
> kbuffer_subbuffer_size() kbuffer_read_at_offset() kbuffer_timestamp()
> kbuffer_read_event() kbuffer_translate_data() kbuffer_free() kbuffer_alloc()
> 
> This was partially found by using a static code analysis program called cppcheck.

This kbuffer API will be used by other (out-of-tree currently) tools..
And I have a plan to add an in-kernel user (perf-ftrace command) later.

Thanks,
Namhyung
