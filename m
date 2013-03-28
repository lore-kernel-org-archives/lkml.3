Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab3C1X7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 19:59:05 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:56626 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab3C1X7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 19:59:02 -0400
Date: Thu, 28 Mar 2013 16:58:30 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Roberto Vitillo <ravitillo@lbl.gov>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, acme@ghostprotocols.net, namhyung@kernel.org
Subject: Re: [PATCH v2] perf: add callgrind conversion tool
Message-ID: <20130328235829.GA22981@us.ibm.com>
References: <CA+BNSkWCX2TVYU26A7qHFqr6F5Pw44wy76BSfnS5MnVDKGCh9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+BNSkWCX2TVYU26A7qHFqr6F5Pw44wy76BSfnS5MnVDKGCh9w@mail.gmail.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032823-3620-0000-0000-000001D1300C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roberto Vitillo [ravitillo@lbl.gov] wrote:
| The proposed patch adds the convert tool to perf which allows to convert a
| perf.data file to a set of callgrind data files which can subsequently be
| displayed with kcachegrind.

Sounds interesting and useful. My only comment is that 'convert' is a
generic term and this is converting to a specific format (i.e callgrind).
In theory we could have conversions to other formats in the future ?

Any chance it could be called 'perf callgrind' ?

Sukadev

