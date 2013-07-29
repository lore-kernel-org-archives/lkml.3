Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629Ab3G2SJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:09:08 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:53807 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab3G2SJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:09:07 -0400
MIME-Version: 1.0
X-Originating-IP: [5.35.97.134]
Date: Mon, 29 Jul 2013 22:09:06 +0400
Message-ID: <CAOJe8K1D-=oZW5=Bba+ytGD5fP84caOYUWCCFdzTnQDhToE0Jg@mail.gmail.com>
Subject: [build failure] perf
From: Denis Kirjanov <kda@linux-powerpc.org>
To: acme@ghostprotocols.net
Cc: mingo@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm having a problem compiling perf(mainline 3.11.0-rc3) on the old
x86 box, probably something wrong with the lex on my system:

    CC util/parse-events.o
cc1: warnings being treated as errors
util/parse-events.c: In function 'parse_events__scanner':
util/parse-events.c:829: warning: implicit declaration of function
'parse_events_lex_init_extra'
util/parse-events.c:829: warning: nested extern declaration of
'parse_events_lex_init_extra'
make: *** [util/parse-events.o] Error 1

Thanks!
