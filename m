Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab3GVO4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 10:56:51 -0400
Received: from mail-gh0-f180.google.com ([209.85.160.180]:59565 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab3GVO4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:56:49 -0400
Date: Mon, 22 Jul 2013 11:56:41 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>
Subject: Re: [PATCH] perf tools: Fix named threads support in perf-script
Message-ID: <20130722145641.GA2157@ghostprotocols.net>
References: <1374185175-28272-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374185175-28272-1-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 18, 2013 at 04:06:15PM -0600, David Ahern escreveu:
> Commit 73994dc broke named thread support in perf-script. The thread
> struct in al is the main thread for a multithreaded process. The
> thread struct used for analysis (e.g., dumping events) should be the
> specific thread for the sample.

Thanks, applied.

- Arnaldo
