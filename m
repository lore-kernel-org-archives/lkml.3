Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab3ETUbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:31:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15548 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637Ab3ETUbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:31:52 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ZSTTxNyh34AA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=7TU8zCdB22MA:10 a=_dhyNQ7klVVMhqw9wcQA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369081909.6828.126.camel@gandalf.local.home>
Subject: Re: [ 094/136 ] e1000e: fix runtime power management transitions
From: Steven Rostedt <rostedt@goodmis.org>
To: jeffrey.t.kirsher@intel.com
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@suse.de>, Aaron Brown <aaron.f.brown@intel.com>
Date: Mon, 20 May 2013 16:31:49 -0400
In-Reply-To: <1369081461.2892.4.camel@jtkirshe-mobl>
References: <20130518021557.139113314@goodmis.org>
	 <20130518021656.829696669@goodmis.org> <5197132A.5030308@openvz.org>
	 <1368855636.2235.136.camel@jtkirshe-mobl>
	 <1369078550.6828.121.camel@gandalf.local.home>
	 <1369081461.2892.4.camel@jtkirshe-mobl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-20 at 13:24 -0700, Jeff Kirsher wrote:

> Drop it from the release please.
> 

Will do, thanks.

-- Steve


