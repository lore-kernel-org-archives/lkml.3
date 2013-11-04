Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab3KDWvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 17:51:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52844 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab3KDWvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 17:51:00 -0500
Message-ID: <527824C3.6000504@zytor.com>
Date: Mon, 04 Nov 2013 14:50:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Russ Anderson <rja@sgi.com>, Josh Boyer <jwboyer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        prarit@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Allow NR_CPUS=1024
References: <20131103101825.GA6605@gmail.com> <20131103102132.GA6807@gmail.com> <20131103155729.GB9944@hansolo.jdub.homelinux.org> <20131104065343.GC13030@gmail.com> <20131104140141.GC9944@hansolo.jdub.homelinux.org> <20131104141051.GA19355@gmail.com> <20131104141615.GD9944@hansolo.jdub.homelinux.org> <20131104155624.GA31656@sgi.com> <20131104174841.GA19498@gmail.com> <ec38985e-ab71-464a-9565-e56b99d34a05@email.android.com> <20131104201111.GA19789@gmail.com>
In-Reply-To: <20131104201111.GA19789@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2013 12:11 PM, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> 8192 maybe?
> 
> Yeah, that makes more sense I guess.
> 

However, I still have serious issues with crap like this because
randconfig is basically broken.  If nothing else we need to get that
feedback to the kconfig maintainers.

	-hpa


