Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566Ab3J2R36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 13:29:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758530Ab3J2R34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 13:29:56 -0400
Date: Tue, 29 Oct 2013 18:29:45 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 2/2] perf kvm: Disable live command if timerfd is not
 supported
Message-ID: <20131029172945.GG7737@krava.brq.redhat.com>
References: <1383064996-20933-1-git-send-email-dsahern@gmail.com>
 <1383064996-20933-2-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383064996-20933-2-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 10:43:16AM -0600, David Ahern wrote:
> If the OS does not have timerfd support (e.g., older OS'es like RHEL5)
> disable perf kvm stat live.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>

looks ok,
Reviewed-by: Jiri Olsa <jolsa@redhat.com>

jirka
