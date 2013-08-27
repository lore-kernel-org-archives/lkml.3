Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab3H0NAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 09:00:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6065 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab3H0NAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 09:00:47 -0400
X-Authority-Analysis: v=2.0 cv=DqnUCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=dRXjL8aGtIIA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=vCXdsJORpdIA:10 a=3nbZYyFuAAAA:8 a=D19gQVrFAAAA:8 a=JBFlyU56so-9qVDoN6cA:9 a=CjuIK1q_8ugA:10 a=oWpn4sYEl2IA:10 a=EvKJbDF4Ut8A:10 a=-0IYxcllaoMA:10 a=IlaMKKf8EWoA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 27 Aug 2013 09:00:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 00/11] trace-cmd: Support the feature recording
 trace data of guests on the host
Message-ID: <20130827090045.4b392273@gandalf.local.home>
In-Reply-To: <521C5E46.9060704@hitachi.com>
References: <20130819094620.26597.79499.stgit@yunodevel>
	<20130820120006.1a4118c5@gandalf.local.home>
	<521AB37E.4050800@hitachi.com>
	<20130826102229.6e0129fe@gandalf.local.home>
	<521C5E46.9060704@hitachi.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Aug 2013 17:07:34 +0900
Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:
et, but I'd like to
> add such feature to fix host/guest clock difference in the next series.
> TSC offset values can be gotten as write_tsc_offset trace event from
> kernel-3.11. (see https://lkml.org/lkml/2013/6/12/72)
> How do you think about this merging feature?

If it's already been merged, then sure, we can use it.

-- Steve

