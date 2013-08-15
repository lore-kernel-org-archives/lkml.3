Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065Ab3HOOVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 10:21:53 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:58599 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab3HOOVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 10:21:51 -0400
Date: Thu, 15 Aug 2013 11:21:45 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/4] perf, tools: Add perf stat --transaction v3
Message-ID: <20130815142145.GA1940@ghostprotocols.net>
References: <1376505267-8902-1-git-send-email-andi@firstfloor.org>
 <1376505267-8902-5-git-send-email-andi@firstfloor.org>
 <20130815132637.GE1861@ghostprotocols.net>
 <20130815140633.GF19750@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130815140633.GF19750@two.firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Aug 15, 2013 at 04:06:33PM +0200, Andi Kleen escreveu:
> Anyways I use this option pretty heavily and the results are good
> to my knowledge.

Have you seen the comments about using evsel->idx?

- Arnaldo
