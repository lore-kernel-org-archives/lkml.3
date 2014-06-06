Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaFFHNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:13:50 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58843 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaFFHNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:13:49 -0400
Subject: [PATCH -tip  0/4] perf/probe: Improve error messages
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 06 Jun 2014 07:13:38 +0000
Message-ID: <20140606071338.6788.799.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a series that improves error messages of perf probe.

 -  Improve the error message if we can not find given member in
    the given structure. (perf probe --add)
 -  Show error code and description only in verbose mode if
    perf probe command is failed.
 -  Improve error messages of perf probe --vars mode.
 -  Improve error messages of perf probe --line mode.

This series is mainly for fixing confusing messages and
for removing the error code which is just a mysterious
number for users.

Thank you,

---

Masami Hiramatsu (4):
      perf/probe: Improve error message for unknown member of data structure
      perf/probe: Show error code and description in verbose mode
      perf/probe: Improve an error message of perf probe --vars mode
      perf/probe: Improve error messages with --line option


 tools/perf/builtin-probe.c     |   23 ++++++++++++++---------
 tools/perf/util/probe-event.c  |   13 +++++++++----
 tools/perf/util/probe-finder.c |   11 +++++++----
 3 files changed, 30 insertions(+), 17 deletions(-)

--
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

