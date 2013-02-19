Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300Ab3BSR5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 12:57:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44675 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933025Ab3BSR5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:57:53 -0500
Message-ID: <5123BC2B.6000304@zytor.com>
Date: Tue, 19 Feb 2013 09:53:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, ebiederm@xmission.com,
        xemul@parallels.com, akpm@linux-foundation.org,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [patch 1/2] kcmp: Make it to depend on CONFIG_KCMP
References: <20130219064800.719149796@openvz.org> <20130219065210.030802820@openvz.org> <5123444D.6000806@suse.cz> <20130219093154.GF20312@moon>
In-Reply-To: <20130219093154.GF20312@moon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 01:31 AM, Cyrill Gorcunov wrote:
> +
> +	  If unsure, say N.
> +

Wrong advice.  In this particular case, Y is the safe alternative.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

