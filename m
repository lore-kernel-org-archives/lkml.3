Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab3ISTuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 15:50:32 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:59384 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab3ISTub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 15:50:31 -0400
Date: Thu, 19 Sep 2013 16:50:20 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Pekka Enberg <penberg@kernel.org>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v6] perf tools: Separate out GTK codes to libperf-gtk.so
Message-ID: <20130919195020.GG17742@ghostprotocols.net>
References: <20130912123156.GA15187@krava.brq.redhat.com>
 <1379053663-13706-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379053663-13706-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 13, 2013 at 03:27:43PM +0900, Namhyung Kim escreveu:
> Separate out GTK codes to a shared object called libperf-gtk.so.  This
> time only GTK codes are built with -fPIC and libperf remains as is.
> Now run GTK hist and annotation browser using libdl.

Thanks, applied

- Arnaldo
