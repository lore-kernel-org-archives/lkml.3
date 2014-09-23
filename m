Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbaIWMCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 08:02:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896AbaIWMCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 08:02:42 -0400
Date: Tue, 23 Sep 2014 14:02:31 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: taeung <treeze.taeung@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] modify error code when perf_session__new() fail.
Message-ID: <20140923120231.GD2979@krava.brq.redhat.com>
References: <1411452737-28188-1-git-send-email-treeze.taeung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411452737-28188-1-git-send-email-treeze.taeung@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
subject should start with 'perf tools:'

On Tue, Sep 23, 2014 at 03:12:17PM +0900, taeung wrote:
> 	Because perf_session__new() could fail
> 	for more reasons than just ENOMEM,
> 	I modified error code(ENOMEM or EINVAL)
> 	into -1.

why the indent?

> 
> Signed-off-by: taeung <treeze.taeung@gmail.com>

the log message needs some love, but the patch looks ok

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka
