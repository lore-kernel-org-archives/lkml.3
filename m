Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3KCRoA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 12:44:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36601 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723Ab3KCRn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 12:43:59 -0500
Message-ID: <52768B48.5030408@zytor.com>
Date: Sun, 03 Nov 2013 09:43:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@redhat.com>, Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        prarit@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Allow NR_CPUS=1024
References: <20131101141148.GH8652@hansolo.jdub.homelinux.org> <20131103101825.GA6605@gmail.com> <20131103102132.GA6807@gmail.com> <20131103155729.GB9944@hansolo.jdub.homelinux.org>
In-Reply-To: <20131103155729.GB9944@hansolo.jdub.homelinux.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2013 07:57 AM, Josh Boyer wrote:
> 
> OK, that makes sense.  So in this scenario, we could probably either:
> 
> a) do away with MAXSMP entirely and just depend on
> CONFIG_CPUMASK_OFFSTACK.
> 
> b) make MAXSMP something even higher than 4096.  Like 5120 or 6144, etc.
> 
> Which would you prefer?  Either is easy enough to code up, I just need
> to know which I should shoot for.
> 

Let's get rid of MAXSMP.

	-hpa


