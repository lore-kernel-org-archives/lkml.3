Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab3HONAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 09:00:07 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:63648 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab3HONAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 09:00:05 -0400
Date: Thu, 15 Aug 2013 09:59:56 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf kvm: remove force option to cmd_record
Message-ID: <20130815125956.GB1861@ghostprotocols.net>
References: <1376512573-85012-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376512573-85012-1-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 14, 2013 at 02:36:13PM -0600, David Ahern escreveu:
> 4a4d371a missed builtin-kvm in the cleanup to remove the force option
> to cmd_record.

Thanks, applied.
