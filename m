Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab3EARd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 13:33:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46148 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab3EARdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 13:33:50 -0400
Message-ID: <518151DD.106@zytor.com>
Date: Wed, 01 May 2013 10:33:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jonas Heinrich <onny@project-insanity.org>
CC: len.brown@intel.com, pavel@ucw.cz, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [Bisected] 3.7-rc1 can't resume (still present in 3.9)
References: <20130218155439.GA902@onny> <cfd96a3d-5834-4687-b9de-9f044f43b588@email.android.com> <20130223131856.GA682@onny> <51293A8B.5060107@zytor.com> <20130320143257.GA473@onny> <20130501170118.GB488@onny>
In-Reply-To: <20130501170118.GB488@onny>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2013 10:01 AM, Jonas Heinrich wrote:
> Hello, I tried the newest kernel, 3.9 today but the bug is still
> present. Applying the attached patch solves the bug for me.
> 
> Best regards, Jonas Heinrich

Okay... WTF is going on here?  Does pmode_behavior just not get set up
correctly?  Since it seems you can get it to wake up with your patch,
perhaps we can get read out the value of pmode_behavior and print it...

	-hpa


