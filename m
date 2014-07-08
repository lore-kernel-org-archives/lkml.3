Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbaGHVuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 17:50:13 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:53374 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbaGHVuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 17:50:11 -0400
Date: Tue, 8 Jul 2014 14:49:23 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        acme@infradead.org
Subject: Re: perf: Add support for full Intel event lists v7
Message-ID: <20140708214923.GA18523@us.ibm.com>
References: <1403910964-11017-1-git-send-email-andi@firstfloor.org>
 <20140708184311.GA14707@us.ibm.com>
 <20140708192833.GI18735@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140708192833.GI18735@two.firstfloor.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070821-5806-0000-0000-000025575AC2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen [andi@firstfloor.org] wrote:
| Works for me with your input file:
| 
| % perf list --events-file t.json
| ...
|   pm_cyc                                             [Cycles completed]
|   pm_inst_cmpl                                       [Instructions completed]

Ah, lower case. 

| 
| > With the above events file, I get "invalid event" for 'PM_INST_CMPL:u'
| 
| It works in new style syntax, like
| 
| perf stat --events-file t.json  -e cpu/pm_inst_cmpl/u  ls

Yes, thanks.

Sukadev

