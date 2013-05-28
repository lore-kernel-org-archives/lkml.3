Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934540Ab3E1PMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 11:12:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51492 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934492Ab3E1PMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 11:12:14 -0400
Message-ID: <51A4C926.2040701@zytor.com>
Date: Tue, 28 May 2013 08:11:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Simon Horman <horms@verge.net.au>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Remove unused /dev/oldmem interface
References: <51A02E50.5020507@gmail.com> <87mwri8wwu.fsf@xmission.com> <20130528143756.GD7088@redhat.com>
In-Reply-To: <20130528143756.GD7088@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 07:37 AM, Vivek Goyal wrote:
> 
> Eric,
> 
> Should we schedule the removal of this interface after 1-2 releases
> and give a warning once if anybody opens /dev/oldmem and tell them
> to use /proc/vmcore instead? 
> 
> I am kind of inclined towards warning approarch. If there is any xyz
> /dev/oldmem user in the wild out there, he/she atleast gets a chance to
> migrate to /proc/vmcore.
> 

This has been discussed ad nauseam at the Kernel Summit.  It doesn't work.

	-hpa


