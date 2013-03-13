Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726Ab3CMPPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 11:15:07 -0400
Received: from mail-gg0-f169.google.com ([209.85.161.169]:53706 "EHLO
	mail-gg0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab3CMPPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 11:15:05 -0400
Message-ID: <5140923B.4040102@gmail.com>
Date: Wed, 13 Mar 2013 08:50:35 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: perf fails to compile for latest Linus tree
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo:

I believe this has been fixed but I don't see it in your tree (perf/core 
or perf/urgent) or in the tip tree:

builtin-annotate.c: In function ‘hists__find_annotations’:
builtin-annotate.c:161:4: error: duplicate case value
builtin-annotate.c:154:4: error: previously used here
make: *** [/tmp/pbuild/builtin-annotate.o] Error 1
make: *** Waiting for unfinished jobs....

David
