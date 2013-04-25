Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576Ab3DYNPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:15:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14656 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757121Ab3DYNPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:15:20 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=BTRBD928usAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=YPD5nf4ZmOMA:10 a=I2R_8oPWS-scC41Is2oA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1366895719.10248.13.camel@gandalf.local.home>
Subject: Re: [ANNOUNCE] 3.4.41-rt55-feat1
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Galbraith <bitbucket@online.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tim Sander <tim.sander@hbm.com>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Thu, 25 Apr 2013 09:15:19 -0400
In-Reply-To: <alpine.LFD.2.02.1304251507370.21884@ionos>
References: <1366760662.9609.176.camel@gandalf.local.home>
	   <2156546.QlsX0XyPQz@dabox> <51792277.8000205@linutronix.de>
	   <1366893374.6139.5.camel@marge.simpson.net>
	  <1366893787.10248.4.camel@gandalf.local.home>
	  <alpine.LFD.2.02.1304251445520.21884@ionos>
	 <1366894324.10248.6.camel@gandalf.local.home>
	 <alpine.LFD.2.02.1304251507370.21884@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-25 at 15:09 +0200, Thomas Gleixner wrote:

> Well, if your application is driven by an external interrupt, then you
> do not need highres timers at all.

Fair point.

-- Steve


