Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab3KVPKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:10:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793Ab3KVPKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:10:41 -0500
Date: Fri, 22 Nov 2013 16:10:36 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [INCOMPLETE PATCH 4/4] perf diff: give Ratio column an
 appropriate color
Message-ID: <20131122151036.GB10881@krava.brq.redhat.com>
References: <1385044427-13995-1-git-send-email-artagnon@gmail.com>
 <1385044427-13995-5-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385044427-13995-5-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 08:03:47PM +0530, Ramkumar Ramachandra wrote:
> In
> 
>   $ perf diff -c ratio
> 
> color the Ratio column using percent_color_snprintf().

why is there 'INCOMPLETE' in the subject?

jirka
