Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaBJS7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:59:37 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:4754 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbaBJS7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 13:59:33 -0500
Message-ID: <1392058770.1099.37.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 00/21] perf, c2c: Add new tool to analyze cacheline
 contention on NUMA systems
From: Davidlohr Bueso <davidlohr@hp.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        eranian@google.com
Date: Mon, 10 Feb 2014 10:59:30 -0800
In-Reply-To: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This can be really useful for us performance folks, thanks. It seems
however that the first two patches in the series are missing.

