Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab3C2ES6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 00:18:58 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33117 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab3C2ES5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 00:18:57 -0400
Date: Fri, 29 Mar 2013 13:18:48 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Roberto Vitillo <ravitillo@lbl.gov>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net
Subject: Re: [PATCH v2] perf: add callgrind conversion tool
Message-ID: <20130329041848.GA27063@danjae>
References: <CA+BNSkWCX2TVYU26A7qHFqr6F5Pw44wy76BSfnS5MnVDKGCh9w@mail.gmail.com>
 <20130328235829.GA22981@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130328235829.GA22981@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 04:58:30PM -0700, Sukadev Bhattiprolu wrote:
> Roberto Vitillo [ravitillo@lbl.gov] wrote:
> | The proposed patch adds the convert tool to perf which allows to convert a
> | perf.data file to a set of callgrind data files which can subsequently be
> | displayed with kcachegrind.
> 
> Sounds interesting and useful. My only comment is that 'convert' is a
> generic term and this is converting to a specific format (i.e callgrind).
> In theory we could have conversions to other formats in the future ?

Maybe we can support converting to CTF or someother formats which have
nice viewer?

Thanks,
Namhyung
