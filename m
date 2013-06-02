Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab3FBTy0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 15:54:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756181Ab3FBTyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 15:54:21 -0400
Date: Sun, 2 Jun 2013 21:49:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 0/2] hw_breakpoint: more cleanups
Message-ID: <20130602194912.GA3277@redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

More cleanups, on top of "[PATCH 0/3] hw_breakpoint: cleanups".

Oleg.

 kernel/events/hw_breakpoint.c |  103 +++++++++++++++++++----------------------
 1 files changed, 47 insertions(+), 56 deletions(-)

