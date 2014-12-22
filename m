Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbaLVTfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 14:35:14 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36301 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286AbaLVTfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 14:35:12 -0500
Date: Mon, 22 Dec 2014 11:34:36 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, dev@codyps.com,
        peterz@infradead.org, hbabu@us.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v6 3/4] perf Documentation: add event parameters
Message-ID: <20141222193436.GB19784@us.ibm.com>
References: <1419234567-22784-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <1419234567-22784-4-git-send-email-sukadev@linux.vnet.ibm.com>
 <20141222143943.GB29096@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141222143943.GB29096@krava.brq.redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14122219-0033-0000-0000-00000162F4AD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa [jolsa@redhat.com] wrote:
| On Sun, Dec 21, 2014 at 11:49:26PM -0800, Sukadev Bhattiprolu wrote:
| > From: Cody P Schafer <cody@linux.vnet.ibm.com>
| > +		In the case of the last example, a value replacing "?" would
| > +		need to be provided by the user selecting the particular event.
| > +		This is referred to as "event parameterization". All
| > +		non-numerical values indicate an event parameter.
| 
| I see.. here's the glitch ;-) I thought we agreed on forcing '?'
| as the value for param events, not 'All non-numerical values'

Yes, it is currently more broad than needed, but it is not really
user input - we are just parsing sysfs entries that developer specified
in the kernel. If necessary, we can tighten that independently ?
| 
| thanks,
| jirka

