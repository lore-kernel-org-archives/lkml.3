Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab3B0T4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 14:56:53 -0500
Received: from relay3.sgi.com ([192.48.152.1]:50240 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751248Ab3B0T4v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 14:56:51 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 1/2] timer_list: split timer_list_show_tickdevices()
Thread-Topic: [PATCH v3 1/2] timer_list: split timer_list_show_tickdevices()
Thread-Index: AQHOFHmo2JX4VYwGVU+tABlS/GtLypiOf18A//+gowg=
Date: Wed, 27 Feb 2013 19:56:48 +0000
Message-ID: <74F10842A85F514CA8D8C487E74474BB2D328C86@P-EXMB1-DC21.corp.sgi.com>
References: <51267626.3030308@codeaurora.org>
 <1361921596-9636-1-git-send-email-nzimmer@sgi.com>
 <1361921596-9636-2-git-send-email-nzimmer@sgi.com>,<512E6076.7070506@codeaurora.org>
In-Reply-To: <512E6076.7070506@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.149.23.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I thought I grabbed the version without it.
I'll fix it.

________________________________________
From: Stephen Boyd [sboyd@codeaurora.org]
Sent: Wednesday, February 27, 2013 1:37 PM
To: Nathan Zimmer
Cc: johnstul@us.ibm.com; tglx@linutronix.de; akpm@linux-foundation.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] timer_list: split timer_list_show_tickdevices()

On 02/26/13 15:33, Nathan Zimmer wrote:
> @@ -246,12 +244,8 @@ static void timer_list_show_tickdevices(struct seq_file *m)
>  #endif
>       SEQ_printf(m, "\n");
>  #endif
> -     for_each_online_cpu(cpu)
> -             print_tickdevice(m, tick_get_device(cpu), cpu);
>       SEQ_printf(m, "\n");
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