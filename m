Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaHKNRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:17:43 -0400
Received: from mail.kernel.org ([198.145.19.201]:55077 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbaHKNRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:17:42 -0400
Date: Mon, 11 Aug 2014 10:17:38 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/8] perf tools: Make __hpp__fmt() receive an additional
 len argument
Message-ID: <20140811131738.GB3277@kernel.org>
References: <1406785662-5534-1-git-send-email-namhyung@kernel.org>
 <1406785662-5534-3-git-send-email-namhyung@kernel.org>
 <20140802133026.GD13375@kernel.org>
 <87r40nfo36.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r40nfo36.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 11, 2014 at 05:05:33PM +0900, Namhyung Kim escreveu:
> Hi Arnaldo,
> 
> On Sat, 2 Aug 2014 10:30:26 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Jul 31, 2014 at 02:47:36PM +0900, Namhyung Kim escreveu:
> >> So that it can properly handle alignment requirements later.  To do
> >> that, add percent_color_len_snprintf() fucntion to help coloring of
> >> overhead columns.
> >
> > Can you elaborate on this description? What is not possible to do before
> > this patch?
> 
> This patch is a preparation that moves hard-coded print width out of the
> format string so that it can be passed from external settings later.

Ok, please add this to the patch description?
 
> > Perhaps a formatted line before this patch and then the same line
> > formatted after the patch?
 
> The default behavior wasn't changed, it's only meaningful when user
> gives field width using -w option.  You can see the difference in the
> description 0/8.

- Arnaldo
