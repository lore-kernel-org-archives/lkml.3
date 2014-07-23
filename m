Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594AbaGWPNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:13:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42769 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758091AbaGWPNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:13:15 -0400
Message-ID: <53CFD0E2.10507@zytor.com>
Date: Wed, 23 Jul 2014 08:12:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Bruno Wolff III <bruno@wolff.to>
CC: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Scheduler regression from caffcdd8d27ba78730d5540396ce72ad022aff2c
References: <20140718145040.GG12054@laptop.lan> <20140718161602.GH12054@laptop.lan> <20140721163528.GA10433@wolff.to> <20140721165212.GO3935@laptop> <20140722094740.GJ12054@laptop.lan> <20140722103857.GK12054@laptop.lan> <20140722121001.GA30631@wolff.to> <20140722130343.GD3935@laptop> <20140722132603.GL12054@laptop.lan> <20140722133514.GM12054@laptop.lan> <20140723151140.GR12054@laptop.lan>
In-Reply-To: <20140723151140.GR12054@laptop.lan>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2014 08:11 AM, Peter Zijlstra wrote:
> 
> OK, so that's become the below patch. I'll feed it to Ingo if that's OK
> with hpa.
> 

I'll grab it directly, it is a bit quicker that way.

	-hpa


