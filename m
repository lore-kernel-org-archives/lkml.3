Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422749Ab3CWAov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 20:44:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9889 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422701Ab3CWAou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 20:44:50 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=F0my4ousGMIA:10 a=MzJa8G2Mr3FL0AqodUgA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363999487.6345.146.camel@gandalf.local.home>
Subject: Re: [ANNOUNCE] 3.6.11-rt31
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Sebastian Sewior <bigeasy@linutronix.de>
Date: Fri, 22 Mar 2013 20:44:47 -0400
In-Reply-To: <alpine.LFD.2.02.1303222227160.22263@ionos>
References: <alpine.LFD.2.02.1303222227160.22263@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-22 at 22:56 +0100, Thomas Gleixner wrote:

> This is the last release for the 3.6 kernel from my side. Steven is
> going to take over and maintain it until 3.8-rt is stabilized.
> 

I have created a new branch in the stable-rt git repo called v3.6-rt.
The first tag for that branch is v3.6.11-rt31

-- Steve


