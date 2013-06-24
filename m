Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab3FXEdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 00:33:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46900 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab3FXEdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 00:33:36 -0400
Message-ID: <51C7CC08.7080604@zytor.com>
Date: Sun, 23 Jun 2013 21:33:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ren Qiaowei <qiaowei.ren@intel.com>
CC: Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Gang Wei <gang.wei@intel.com>
Subject: Re: [PATCH] x86, tboot: provide debugfs interfaces to access TXT
 log
References: <1371974050-21436-1-git-send-email-qiaowei.ren@intel.com> <1371976573.3137.20.camel@joe-AO722> <51C7B540.9020507@intel.com>
In-Reply-To: <51C7B540.9020507@intel.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2013 07:56 PM, Ren Qiaowei wrote:
>>
> Well, I guess that I can use iomem related interface to fix these
> warnings caused by sparse.
> 

And you SHOULD.  Passing around pointers to I/O space without even
annotating them isn't really very clean.

	-hpa


