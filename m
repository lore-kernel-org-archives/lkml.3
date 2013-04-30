Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709Ab3D3CV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 22:21:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2260 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387Ab3D3CVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 22:21:55 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=BTRBD928usAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=YPD5nf4ZmOMA:10 a=f-7Xb6j5qNcajQaW31kA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1367288513.30667.55.camel@gandalf.local.home>
Subject: Re: [ANNOUNCE] 3.4.41-rt55-feat3
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: RT <linux-rt-users@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Carsten Emde <C.Emde@osadl.org>, John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Mon, 29 Apr 2013 22:21:53 -0400
In-Reply-To: <1367283987.30667.49.camel@gandalf.local.home>
References: <1367283987.30667.49.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-29 at 21:06 -0400, Steven Rostedt wrote:
> Dear RT Folks,
> 
> I'm pleased to announce the 3.4.41-rt55-feat3 feature release.
> 
> Note, I first uploaded -feat2 then realized I didn't add a compile fix by
> Mike Galbraith, and then created the -feat3 with that fix.
> 

Because of the -feat2/3 screw up, I forgot to thank Sebastian Andrzej
Siewior for doing the SLUB backport.

-- Steve


