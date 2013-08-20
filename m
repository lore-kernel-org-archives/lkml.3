Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614Ab3HTSH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 14:07:57 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:46901 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3HTSH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 14:07:56 -0400
Date: Tue, 20 Aug 2013 15:07:49 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf trace: Make command line arguments consistent with
 perf-record - v3
Message-ID: <20130820180749.GF8488@ghostprotocols.net>
References: <1377018945-21940-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377018945-21940-1-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Aug 20, 2013 at 11:15:45AM -0600, David Ahern escreveu:
> Common arguments like thread id, CPU list, mmap pages, etc should be
> consistent across perf commands.
> 
> v3: Updated man page
> v2: rebased to latest core branch

Thanks, applied.

- Arnaldo
