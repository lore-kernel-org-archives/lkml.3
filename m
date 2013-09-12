Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646Ab3ILBUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 21:20:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15430 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab3ILBUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 21:20:52 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=xF6n-TA6XmAA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=WmdT_Ksgc64A:10 a=DfNHnWVPAAAA:8 a=danhDmx_AAAA:8 a=AtpdFBbmAAAA:8 a=tfDV0ovBAAAA:8 a=MqkXBiABcdmGZFXWEPQA:9 a=CjuIK1q_8ugA:10 a=NDlYDJSHyeAA:10 a=xsHjhf9YS8kA:10 a=pFA80ryo3kYA:10 a=kTNIM3Gb97oA:10 a=lBRciGGoxdUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 11 Sep 2013 21:20:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [146/251] zram: use zram->lock to protect zram_free_page() in
 swap free notify path
Message-ID: <20130911212051.459dbd59@gandalf.local.home>
In-Reply-To: <87y573rbp9.fsf@canonical.com>
References: <20130911042707.738353451@goodmis.org>
	<20130911042916.643722187@goodmis.org>
	<87y573rbp9.fsf@canonical.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Sep 2013 09:42:42 +0100
Luis Henriques <luis.henriques@canonical.com> wrote:

> Steven Rostedt <rostedt@goodmis.org> writes:
> 
> > 3.6.11.9-rc1 stable review patch.
> > If anyone has any objections, please let me know.
> 
> This commit seems to cause regressions [1].  There's a fix for it with
> commit a0c516cbfc7452c8cbd564525fef66d9f20b46d1 but it doesn't apply
> cleanly (it probably requires several other commits to be
> backported).  Thus, I am reverting it from the 3.5 extended stable
> kernel.
> 
> [1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1215513
> 

Thanks! I reverted it too.

-- Steve
