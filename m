Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761098Ab3GSSh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 14:37:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10638 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761078Ab3GSShz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 14:37:55 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=FL2meh5BS9AA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=BRhfnD90nwUA:10 a=75DaBEQ58bygQ0zNSpYA:9 a=QEXdDO2ut3YA:10 a=zONtY1MbEoIA:10 a=k_q4HGjFKUkA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374259073.3356.22.camel@gandalf.local.home>
Subject: Re: [PATCH v5] power: new trace event to print device suspend and
 resume time
From: Steven Rostedt <rostedt@goodmis.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "len.brown@intel.com" <len.brown@intel.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "joe@perches.com" <joe@perches.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Date: Fri, 19 Jul 2013 14:37:53 -0400
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E61743340@sisaex01sj>
References: <1374187352-3283-1-git-send-email-shuah.kh@samsung.com>
	 <1374188013.3356.7.camel@gandalf.local.home>
	 <B8EFE96D1287C24090BAD9D858E15E61743340@sisaex01sj>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-19 at 18:29 +0000, Shuah Khan wrote:

> Tried with temp variables. Patch is on its way with temp variables. I 
> generated .s with and without temp variables and didn't see any 
> difference. Should I be seeing a difference, if so what am I missing?
> 
> In any case, you have the patch v6 with temp variables.
> 

There may not be, matters how good gcc is in optimization.

Temp variables are fine to keep if they work.

-- Steve


