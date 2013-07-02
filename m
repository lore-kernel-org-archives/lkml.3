Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab3GBXGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 19:06:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21873 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab3GBXGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 19:06:07 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=FBRt8xqedWUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=XzXmEfpJ-cEA:10 a=dwh-FDLDIju6XW70FowA:9 a=QEXdDO2ut3YA:10 a=SoNlTTZyX3kA:10 a=DS8zmN-RtYMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372806366.22688.72.camel@gandalf.local.home>
Subject: Re: [PATCH] uprobes: fix return value in error handling path
From: Steven Rostedt <rostedt@goodmis.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, srikar@linux.vnet.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 02 Jul 2013 19:06:06 -0400
In-Reply-To: <1371488199.18733.20.camel@gandalf.local.home>
References: <51B964FF.5000106@huawei.com>
	 <1371488199.18733.20.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-17 at 12:56 -0400, Steven Rostedt wrote:
> Srikar,
> 
> Can you give an Ack (or nack) for this?
> 

This looks rather obvious, I'll apply it and also tag it for stable.

-- Steve


