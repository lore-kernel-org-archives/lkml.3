Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab3C2Euo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 00:50:44 -0400
Received: from fe2.lbl.gov ([128.3.41.134]:42560 "EHLO fe2.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936Ab3C2Eun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 00:50:43 -0400
X-Ironport-SBRS: 2.6
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai8CAGYcVVHRVYBIfmdsb2JhbABDhhK8Qn0IFg4BAQkLDAgUKIIfAQEFeRALCw0uIhIBBQEcBhOIFKFUnhyPGAeDQAOIeI1wjyYWKYROHA
X-IronPort-AV: E=Sophos;i="4.87,370,1363158000"; 
   d="scan'208";a="14875700"
MIME-Version: 1.0
In-Reply-To: <20130329041848.GA27063@danjae>
References: <CA+BNSkWCX2TVYU26A7qHFqr6F5Pw44wy76BSfnS5MnVDKGCh9w@mail.gmail.com>
	<20130328235829.GA22981@us.ibm.com>
	<20130329041848.GA27063@danjae>
Date: Thu, 28 Mar 2013 21:50:41 -0700
Message-ID: <CA+BNSkXYCO05je+KoG+1Wk=ADg=4ZNYbZG=e21f3hE7+LA_-uQ@mail.gmail.com>
Subject: Re: [PATCH v2] perf: add callgrind conversion tool
From: Roberto Vitillo <ravitillo@lbl.gov>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, acme@ghostprotocols.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 9:18 PM, Namhyung Kim <namhyung@kernel.org> wrote:
> On Thu, Mar 28, 2013 at 04:58:30PM -0700, Sukadev Bhattiprolu wrote:
>> Roberto Vitillo [ravitillo@lbl.gov] wrote:
>> | The proposed patch adds the convert tool to perf which allows to convert a
>> | perf.data file to a set of callgrind data files which can subsequently be
>> | displayed with kcachegrind.
>>
>> Sounds interesting and useful. My only comment is that 'convert' is a
>> generic term and this is converting to a specific format (i.e callgrind).
>> In theory we could have conversions to other formats in the future ?
>
> Maybe we can support converting to CTF or someother formats which have
> nice viewer?

That sounds like a good idea. I could add a -t option to the convert tool
that allows to specify the output format. Initially the tool would have just
the callgrind one but later on we can add support for CTF and possibly
other formats.

Roberto
