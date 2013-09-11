Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab3IKMZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 08:25:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11051 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab3IKMZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 08:25:50 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Jd0jaqIKetIA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=NR4DbnF22M8A:10 a=QyXUC8HyAAAA:8 a=1Bw8bsyBgav4PYRO3GUA:9 a=CjuIK1q_8ugA:10 a=dGJ0OcVc7YAA:10 a=T1N8hdXCnR8A:10 a=Z2fySeUBMngA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 11 Sep 2013 08:25:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Berg, Johannes" <johannes.berg@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [199/251] genetlink: fix family dump race
Message-ID: <20130911082548.743f830a@gandalf.local.home>
In-Reply-To: <1DC40B07CD6EC041A66726C271A73AE61AABAF33@IRSMSX102.ger.corp.intel.com>
References: <20130911042707.738353451@goodmis.org>
	<20130911042925.297207769@goodmis.org>
	<1DC40B07CD6EC041A66726C271A73AE61AABAF33@IRSMSX102.ger.corp.intel.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Sep 2013 06:50:10 +0000
"Berg, Johannes" <johannes.berg@intel.com> wrote:

> > 3.6.11.9-rc1 stable review patch.
> > If anyone has any objections, please let me know.
> 
> Yes, this patch is broken and we reverted it upstream. 

Thanks! I'll revert it.

-- Steve
