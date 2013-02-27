Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760818Ab3B0Thm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 14:37:42 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62612 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab3B0Thk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 14:37:40 -0500
X-IronPort-AV: E=Sophos;i="4.84,750,1355126400"; 
   d="scan'208";a="26859745"
Message-ID: <512E6076.7070506@codeaurora.org>
Date: Wed, 27 Feb 2013 11:37:26 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Nathan Zimmer <nzimmer@sgi.com>
CC: johnstul@us.ibm.com, tglx@linutronix.de, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] timer_list: split timer_list_show_tickdevices()
References: <51267626.3030308@codeaurora.org> <1361921596-9636-1-git-send-email-nzimmer@sgi.com> <1361921596-9636-2-git-send-email-nzimmer@sgi.com>
In-Reply-To: <1361921596-9636-2-git-send-email-nzimmer@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/13 15:33, Nathan Zimmer wrote:
> @@ -246,12 +244,8 @@ static void timer_list_show_tickdevices(struct seq_file *m)
>  #endif
>  	SEQ_printf(m, "\n");
>  #endif
> -	for_each_online_cpu(cpu)
> -		print_tickdevice(m, tick_get_device(cpu), cpu);
>  	SEQ_printf(m, "\n");
>  }

The duplicate newline is here again?

> -#else
> -static void timer_list_show_tickdevices(struct seq_file *m) { }
>  #endif
>  
>  static int timer_list_show(struct seq_file *m, void *v)
>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

