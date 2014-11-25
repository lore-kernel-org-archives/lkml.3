Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaKYJeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 04:34:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbaKYJeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 04:34:18 -0500
Date: Tue, 25 Nov 2014 10:33:52 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, acme@kernel.org, mingo@kernel.org,
        peterz@infradead.organton, Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <michaele@au1.ibm.com>
Subject: Re: perf: Add support for full Intel event lists v8
Message-ID: <20141125093352.GB30861@krava.brq.redhat.com>
References: <1406762570-16694-1-git-send-email-andi@firstfloor.org>
 <20141124223736.GA13184@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141124223736.GA13184@us.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 02:37:36PM -0800, Sukadev Bhattiprolu wrote:
> Andi Kleen [andi@firstfloor.org] wrote:
> 
> | Since it seems the download mechanism is controversal, 
> | I removed the downloader for now until a suitable distribution
> | method with kernel.org can be established. This is just
> | the rest of the perf JSON event code that should hopefully
> | not be controversal.
> 
> Ingo, Jiri, Andi,
> 
> Can we get this patchset merged please ? It is a step forward
> in eliminating raw event codes right ?
> 
> We added hundreds of events to sysfs for Power7. We don't
> want to do the same for Power8 because this JSON file solution
> is clearly better.
> 
> But we currently have a regression in functionality from Power7
> to Power8 :-(
> 
> Even if 'perf download' is left out this patchset is still
> useful IMHO. Users (specially those who currently struggle
> with raw codes, are highly qualified and) could wget the
> JSON files as and when needed. 
> 
> Being able to install the JSON files and download updates is
> a big plus, but is something thse users can live without for
> now.

hi,
I talked to Andi about this on LinuxCon and he said he works
on that.. his current struggle was to get the ftp space IIRC

not sure whats the current status now, but I had the feeling
it wont take long..

jirka
