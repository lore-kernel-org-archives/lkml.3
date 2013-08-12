Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab3HLADQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 20:03:16 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:33779 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab3HLADP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 20:03:15 -0400
Message-ID: <5208263D.2080205@opersys.com>
Date: Sun, 11 Aug 2013 21:03:09 -0300
From: Karim Yaghmour <karim.yaghmour@opersys.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Steven Rostedt <rostedt@goodmis.org>, mingo@elte.hu
Subject: Reading perf counters at ftrace trace boundaries
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Wondering if there's a way for reading perf counters in the kernel. I'd
like to read/record perf counters on ftrace function tracing
entries/exits to provide a rundown of the value of various counters on
function call boundaries.

[ Steven: apologies for sending you a duplicate here of what I somewhat
already sent privately. ]

-- 
Karim Yaghmour
CEO - Opersys inc. / www.opersys.com
http://twitter.com/karimyaghmour
