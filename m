Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab3HVPlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 11:41:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57673 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753Ab3HVPly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 11:41:54 -0400
Date: Thu, 22 Aug 2013 12:41:40 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/4] perf, tools: Add perf stat --transaction v5
Message-ID: <20130822154140.GC21880@ghostprotocols.net>
References: <1377128846-977-1-git-send-email-andi@firstfloor.org>
 <1377128846-977-5-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377128846-977-5-git-send-email-andi@firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 21, 2013 at 04:47:26PM -0700, Andi Kleen escreveu:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add support to perf stat to print the basic transactional execution statistics:
> Total cycles, Cycles in Transaction, Cycles in aborted transsactions
> using the in_tx and in_tx_checkpoint qualifiers.
> Transaction Starts and Elision Starts, to compute the average transaction
> length.

Ack

- Arnaldo
